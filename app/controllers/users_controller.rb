class UsersController < InheritedResources::Base
  skip_before_filter :authenticate_user!, :only => [:new, :create]
  skip_before_filter :log_viewed_item

  def create
    create! do |success, failure|
      success.html { redirect_to root_path }
    end
  end

  def profile
    @user = current_user
  end
end
