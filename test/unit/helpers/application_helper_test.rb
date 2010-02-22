require File.dirname(__FILE__) + '/../../test_helper'
require 'action_view/test_case'
require 'action_view/helpers'
require 'open-uri'

class ApplicationHelperTest < ActionView::TestCase

  include ApplicationHelper                                                            
  
  should "link to create a new model" do
    assert_equal add_new('Add Lead','/leads/new'), "<a href='/leads/new' id='new'><b>+</b>Add Lead</a>"
  end

end
