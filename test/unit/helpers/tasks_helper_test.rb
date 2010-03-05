require File.dirname(__FILE__) + '/../../test_helper'
require 'action_view/test_case'
require 'action_view/helpers'
require 'open-uri'


class TasksHelperTest < ActionView::TestCase

  include TasksHelper
  include ActiveHelper
  include ActionController::UrlWriter
  include ActionController::Caching
  
  context "task_asset_info" do
    
    should "return nothing if task has no asset" do
      @task = Task.make
      assert_equal nil, task_asset_info(@task)
    end
    
    should "return nothing if user is on the show page" do
      setup do
        @controller = LeadsController.new
        self.stubs(:controller).returns(@controller)
        @request = ActionController::TestRequest.new
        @request.stubs(:host).returns('localhost:3000')
        @controller.stubs(:request).returns(@request)
        @response = ActionController::TestResponse.new
        self.stubs(:controller_name).returns('leads')
        self.stubs(:action_name).returns('show')
        get :show
      end
      @task = Task.make
      assert_equal nil, task_asset_info(@task)
    end
    
    context "asset is a Lead" do
      should "return contact info" do
        @task = Task.make :asset => Lead.make(:with_contact_info)
        assert_equal "<br/><small class='xs'><span class='asset_type lead'>Lead: </span> | Email: <a href='mailto:e.feldermeier@yahoo.de'>e.feldermeier@yahoo.de</a> | Phone: 102.321.2456</small>", task_asset_info(@task)
      end
    end

    context "asset is a Contact" do
      should "return contact info" do
        @task = Task.make :asset => Contact.make(:with_contact_info)
        assert_equal "<br/><small class='xs'><span class='asset_type contact'>Contact: </span> | Email: <a href='mailto:contact@info.com'>contact@info.com</a> | Phone: 102.321.2456</small>", task_asset_info(@task)
      end
    end
    
    context "asset is an Account" do
      should "return contact info" do
        @task = Task.make :asset => Account.make(:with_contact_info)
        assert_equal "<br/><small class='xs'><span class='asset_type account'>Account: </span> | Email: <a href='mailto:info@contactinc.com'>info@contactinc.com</a> | Phone: 102.321.2456</small>", task_asset_info(@task)
      end
    end
    
  end
end
