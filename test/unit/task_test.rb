require 'test_helper.rb'

class TaskTest < ActiveSupport::TestCase
  context "Class" do
    should_have_constant :categories

    context 'daily_email' do
      setup do
        @call_erich = Task.make(:call_erich, :due_at => 'due_today')
        @call_markus = Task.make(:call_markus, :due_at => 'due_today', :user => User.make(:benny))
        ActionMailer::Base.deliveries.clear
      end

      should 'send an email to all users who have tasks due for the day' do
        Task.daily_email
        assert_sent_email do |email|
          email.to.include?(@call_erich.user.email) && email.body.match(/#{@call_erich.id}/) &&
            email.body.match(/#{@call_erich.name}/)
        end
        assert_sent_email do |email|
          email.to.include?(@call_markus.user.email) && email.body.match(/#{@call_markus.id}/) &&
            email.body.match(/#{@call_markus.name}/)
        end
      end

      should 'send a summary email to each user, with all tasks in one email' do
        @call_markus.update_attributes :user_id => @call_erich.user_id
        Task.daily_email
        assert_sent_email do |email|
          email.to.include?(@call_markus.user.email) && email.body.match(/#{@call_markus.id}/) &&
            email.body.match(/#{@call_erich.id}/) && email.body.match(/#{@call_markus.name}/) &&
            email.body.match(/#{@call_erich.name}/)
        end
      end

      should 'only send tasks for the current day' do
        @call_erich.update_attributes :due_at => 'due_next_week'
        Task.daily_email
        assert_sent_email do |email|
          email.to.include?(@call_markus.user.email) && email.body.match(/#{@call_markus.id}/) &&
            !email.body.match(/#{@call_erich.id}/)
        end
      end
    end
  end

  context 'Named Scopes' do
    setup do
      @task = Task.make(:call_erich)
    end

    context 'overdue' do
      setup do
        @task.update_attributes :due_at => 'due_next_week'
        @task2 = Task.make :due_at => 'overdue'
      end

      should 'return tasks which are due yesterday or earlier' do
        assert_equal [@task2], Task.overdue
      end
    end

    context 'due_today' do
      setup do
        @task.update_attributes :due_at => 'overdue'
        @task2 = Task.make :due_at => 'due_today'
      end

      should 'return tasks which are due today' do
        assert_equal [@task2], Task.due_today
      end
    end

    context 'due_tomorrow' do
      setup do
        @task.update_attributes :due_at => 'overdue'
        @task2 = Task.make :due_at => 'due_tomorrow'
      end

      should 'return tasks which are due tomorrow' do
        assert_equal [@task2], Task.due_tomorrow
      end
    end

    context 'due_next_week' do
      setup do
        @task.update_attributes :due_at => 'overdue'
        @task2 = Task.make :due_at => 'due_next_week'
      end

      should 'return tasks which are due next week' do
        assert_equal [@task2], Task.due_next_week
      end
    end

    context 'due_later' do
      setup do
        @task.update_attributes :due_at => 'overdue'
        @task2 = Task.make :due_at => 6.months.from_now
      end

      should 'return tasks which are due after next week' do
        assert_equal [@task2], Task.due_later
      end
    end

    context 'completed_today' do
      setup do
        @task2 = Task.make
        @task2.update_attributes :completed_by_id => @task2.user_id
        @task2.update_attributes :completed_at => Time.zone.now
      end

      should 'return tasks which were completed today' do
        assert_equal [@task2], Task.completed_today
      end
    end

    context 'completed_yesterday' do
      setup do
        @task2 = Task.make
        @task2.update_attributes :completed_by_id => @task2.user_id
        @task2.update_attributes :completed_at => Time.zone.now.yesterday.utc
      end

      should 'return tasks which were completed yesterday' do
        assert_equal [@task2], Task.completed_yesterday
      end
    end

    context 'completed_last_week' do
      setup do
        @task2 = Task.make
        @task2.update_attributes :completed_by_id => @task2.user_id
        @task2.update_attributes :completed_at => Time.zone.now.beginning_of_week.utc - 7.days
      end

      should 'return tasks which where completed last week' do
        assert_equal [@task2], Task.completed_last_week
      end
    end

    context 'completed_last_month' do
      setup do
        @task2 = Task.make
        @task2.update_attributes :completed_by_id => @task2.user_id
        @task2.update_attributes :completed_at => Time.zone.now.beginning_of_month - 1.month
      end

      should 'return tasks which where completed last month' do
        assert_equal [@task2], Task.completed_last_month
      end
    end

    context 'completed' do
      setup do
        @task = Task.make(:call_erich)
        @task.update_attributes :completed_by_id => @task.user.id
        @incomplete = Task.make
      end

      should 'return all completed tasks' do
        assert_equal [@task], Task.completed
      end
    end

    context 'assigned' do
      setup do
        @benny = User.make(:benny)
        @assigned = Task.make(:call_erich, :assignee => @benny)
        @unassigned = Task.make
      end

      should 'return all assigned tasks' do
        assert_equal [@assigned], Task.assigned
      end
    end

    context 'for' do
      should 'return all tasks created by the supplied user' do
        assert_equal [@task], Task.for(@task.user)
      end

      should 'return all tasks assigned to the current user' do
        @benny = User.make(:benny)
        @task.update_attributes :assignee_id => @benny.id
        assert_equal [@task], Task.for(@benny)
      end

      should 'not return tasks not created by or assigned to the supplied user' do
        @benny = User.make(:benny)
        assert_equal [], Task.for(@benny)
      end
    end

    context 'incomplete' do
      should 'return tasks which have not been completed' do
        assert_equal [@task], Task.incomplete
        @task.completed_by_id = @task.user_id
        @task.save
        assert_equal [], Task.incomplete
      end
    end

    context 'due_today' do
      setup do
        @call_erich = Task.make(:call_erich, :due_at => 'due_today')
        @call_markus = Task.make(:call_markus, :due_at => 'due_next_week')
      end

      should 'return tasks which are due before 00:00:00 tomorrow' do
        assert_equal [@call_erich], Task.due_today
      end
    end
  end

  context "Instance" do
    setup do
      @task = Task.make_unsaved
    end

    context 'activity logging' do
      setup do
        @task.save!
        @task = Task.find(@task.id)
      end

      should 'log activity when created' do
        assert @task.activities.any? {|a| a.action == 'Created' }
      end

      should 'log activity when update' do
        @task.update_attributes :name => 'test update'
        assert @task.activities.any? {|a| a.action == 'Updated' }
      end

      should 'not log update activity when created' do
        assert_equal 1, @task.activities.count
      end

      should 'log activity when re-assigned' do
        @task.update_attributes :assignee_id => User.make(:benny).id
        assert @task.activities.any? {|a| a.action == 'Re-assigned' }
      end

      should 'not log update activity when re-assigned' do
        @task.update_attributes :assignee_id => User.make(:benny).id
        assert !@task.activities.any? {|a| a.action == 'Updated' }
      end

      should 'log activity when completed' do
        @task.completed_by_id = @task.user.id
        @task.save!
        assert @task.activities.any? {|a| a.action == 'Completed' }
      end
    end


    should 'send a notification email to the assignee if the assignee is changed' do
      @task.save!
      @benny = User.make(:benny)
      ActionMailer::Base.deliveries.clear
      @task.update_attributes :assignee_id => @benny.id
      assert_sent_email do |email|
        email.to.include?(@benny.email) && email.body.match(/\/tasks\//) &&
          email.subject.match(/You have been assigned a new task/)
      end
    end

    should 'not send a notification email if the assignee was not changed' do
      @task.save!
      ActionMailer::Base.deliveries.clear
      @task.update_attributes :assignee_id => @task.assignee_id
      assert_equal 0, ActionMailer::Base.deliveries.length
    end

    context 'completed?' do
      should 'be true when task has been completed' do
        @task.completed_by_id = @task.user_id
        @task.save!
        assert @task.completed?
      end

      should 'be false when the task has not been completed' do
        assert !@task.completed?
      end
    end

    context 'completed_by_id=' do
      setup do
        @task.save!
      end

      should 'set the task completed at time' do
        assert @task.completed_at.nil?
        @task.completed_by_id= @task.user_id
        assert !@task.completed_at.nil?
      end

      should 'set the task completed by' do
        assert @task.completed_by_id.nil?
        @task.completed_by_id = @task.user_id
        assert_equal @task.user_id, @task.completed_by_id
      end
    end

    context 'due_in_words' do
      should 'return overdue when due_at is at the end of a day and in the past' do
        @task.due_at = Time.zone.now.yesterday.end_of_day - 1.second
        assert_equal 'overdue', @task.due_at_in_words
      end

      should 'return "due_today" when due_at is at the end of today' do
        @task.due_at = Time.zone.now.end_of_day - 1.second
        assert_equal 'due_today', @task.due_at_in_words
      end

      should 'return "due_tomorrow" when due_at is at the end of tomorrow' do
        @task.due_at = Time.zone.now.tomorrow.end_of_day - 1.second
        assert_equal 'due_tomorrow', @task.due_at_in_words
      end

      #should 'return "due_this_week" when due_at is at the end of a day and some time this week, but further away than tomorrow' do
      #  @task.due_at = Time.zone.now.end_of_week - 1.second
      #  assert_equal 'due_this_week', @task.due_at_in_words
      #end

      should 'return "due_next_week" when due_at is at the end of a day sometime during the following week' do
        @task.due_at = Time.zone.now.next_week.end_of_week - 1.second
        assert_equal 'due_next_week', @task.due_at_in_words
      end

      should 'return "due_later" when due_at is at the end of a day and further away than one week' do
        @task.due_at = (Time.zone.now.next_week.end_of_week + 1.day) - 1.second
        assert_equal 'due_later', @task.due_at_in_words
      end

      should 'return specific time if due_at does not match any of the above cases' do
        time = Time.zone.now
        @task.due_at = time
        assert_equal time.to_s(:short), @task.due_at_in_words
      end
    end

    context 'due_at=' do
      should 'set due_at to midnight yesterday when "overdue" is specified' do
        @task.due_at = 'overdue'
        assert Time.zone.now.yesterday.end_of_day.to_i == @task.due_at.to_i
      end

      should 'set due_at to midnight today when "due_today" is specified' do
        @task.due_at = 'due_today'
        assert Time.zone.now.end_of_day.to_i == @task.due_at.to_i
      end

      should 'set due_at to midnight tomorrow when "due_tomorrow" is specified' do
        @task.due_at = 'due_tomorrow'
        assert Time.zone.now.tomorrow.end_of_day.to_i  == @task.due_at.to_i
      end

      should 'set due_at to end of week if "due_this_week" is specified' do
        @task.due_at = 'due_this_week'
        assert Time.zone.now.end_of_week.to_i == @task.due_at.to_i
      end

      should 'set due_at to end of next week if "due_next_week" is specified' do
        @task.due_at = 'due_next_week'
        assert Time.zone.now.next_week.end_of_week.to_i == @task.due_at.to_i
      end

      should 'set due_at to 100 years from midnight if "due_later" is specified' do
        @task.due_at = 'due_later'
        assert((Time.zone.now.end_of_day + 5.years).to_i == @task.due_at.to_i)
      end

      should 'set due_at to specified time, if an actual time is specified' do
        time = 5.minutes.from_now
        @task.due_at = time
        assert_equal time.to_i, @task.due_at.to_i
      end
    end
  end
end
