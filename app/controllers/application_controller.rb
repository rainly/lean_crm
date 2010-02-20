# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :authenticate_user!
  before_filter :configuration_check
  after_filter :log_viewed_item

protected
  def log_viewed_item
    subject = instance_variable_get("@#{controller_name.singularize}")
    if subject and current_user
      Activity.log(current_user, subject, 'Viewed')
    end
  end

  def return_to_or_default( default )
    if params[:return_to] and not params[:return_to].blank?
      redirect_to params[:return_to]
    else
      redirect_to default
    end
  end

  def configuration_check
    unless @configuration ||= Configuration.first
      Configuration.create!
    end
  end
end
