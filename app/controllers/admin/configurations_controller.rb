class Admin::ConfigurationsController < Admin::AdminController
  inherit_resources

  def update
    update! do |success, failure|
      success.html { redirect_to admin_configuration_path }
    end
  end

protected
  def resource
    @configuration ||= Configuration.first
  end
end
