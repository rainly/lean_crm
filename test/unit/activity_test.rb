require 'test_helper.rb'

class ActivityTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_constant :actions

    context 'log' do
      setup do
        @lead = Lead.make(:erich)
      end

      should 'create a new activity with the supplied user, model and action' do
        activities = Activity.count
        Activity.log(@lead.user, @lead, 'Viewed')
        assert_equal activities + 1, Activity.count
        assert Activity.first(:conditions => { :user_id => @lead.user_id, :subject_id => @lead.id,
                              :subject_type => 'Lead', :action => Activity.actions.index('Viewed') })
      end
    end
  end

  context 'Instance' do
    setup do
      @activity = Activity.make_unsaved(:viewed_erich)
    end

    should 'be valid' do
      assert @activity.valid?
    end

    should 'be invalid without user_id' do
      @activity.user_id = nil
      assert !@activity.valid?
      assert @activity.errors.on(:user_id)
    end

    should 'be invalid without subject_id' do
      @activity.subject_id = nil
      assert !@activity.valid?
      assert @activity.errors.on(:subject_id)
    end

    should 'be invalid without subject_type' do
      @activity.subject_type = nil
      assert !@activity.valid?
      assert @activity.errors.on(:subject_type)
    end
  end
end
