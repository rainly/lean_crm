class PagesController < ApplicationController

  before_filter :find_activities, :only => [:index]

protected
  def find_activities
    @activities ||= current_user.activities
  end
end
