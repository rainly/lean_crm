require File.dirname(__FILE__) + '/../../test_helper'
require 'action_view/test_case'
require 'action_view/helpers'
require 'open-uri'

class ActiveHelperTest < ActionView::TestCase

  include ActiveHelper
  include ActionController::UrlWriter
  include ActionController::Caching

  context "When on the accounts controller" do
    setup do
      @controller = AccountsController.new
      self.stubs(:controller).returns(@controller)
      @request = ActionController::TestRequest.new
      @request.stubs(:host).returns('localhost:3000')
      @controller.stubs(:request).returns(@request)
      @response = ActionController::TestResponse.new
      self.stubs(:controller_name).returns('accounts')
      self.stubs(:action_name).returns('new')
      get :new
    end

    context "controller_is" do
      should "be true for accounts" do
        assert controller_is('accounts')
      end

      should "be true for accounts/jobs" do
        assert controller_is('accounts', 'jobs')
      end

      should "be false for jobs" do
        assert !controller_is('jobs')
      end
    end

    context "action_is" do
      should "be true if current action is in the supplied list" do
        assert action_is('new')
        assert action_is('new', 'edit')
      end

      should "be false if current action is not in the supplied list" do
        assert !action_is('edit')
      end
    end

    context "partial_is" do
      should "be true if params[:partial] is the specified value" do
        self.stubs(:params).returns({ :partial => 'boards' })
        assert partial_is('boards')
      end

      should "be false if params[:partial] is not the specified value" do
        self.stubs(:params).returns({ :partial => 'askjfafew' })
        assert !partial_is('boards')
      end
    end

    context "controller_action_is" do
      should "be true if for current controller/action combination" do
        assert controller_action_is('accounts', 'new')
      end

      should "be false for incorrect controller/action combination" do
        assert !controller_action_is('accounts', 'edit')
        assert !controller_action_is('jobs', 'new')
      end
    end

    context "active_if" do
      should "return active if true" do
        assert_equal 'active', active_if(true)
      end

      should "return inactive if false" do
        assert_equal 'inactive', active_if(false)
      end
    end

  # TODO: sort out these tests, although they were originally passing, they were testing if true == true
  def test_nav_link_to
    #assert_equal "<a href='/accounts' class='active'>New Account</a>", nav_link_to('New Account',{:controller=>'accounts',:action=>'new'},controller_is('accounts'))
    #assert_equal "<a href='/jobs/new'>New Account</a>", nav_link_to('Jobs',{:controller=>'jobs',:action=>'index'},controller_is('jobs'))
    #assert_equal "<a href='/jobs/new' id='test'>New Account</a>", nav_link_to('Jobs',{:controller=>'jobs',:action=>'index'},controller_is('jobs'), :id => 'test')
  end
end
