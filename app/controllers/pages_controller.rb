class PagesController < ApplicationController

  before_filter :find_activities, :only => [:index]

protected
  def find_activities
    @activities ||= Activity.action_is_not('Viewed').visible_to(current_user)
  end
end
