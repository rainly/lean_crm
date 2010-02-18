class Admin::AdminController < ApplicationController

  layout 'admin'

  skip_before_filter :authenticate_user!
  skip_before_filter :log_viewed_item
  before_filter :authenticate_admin!
end
