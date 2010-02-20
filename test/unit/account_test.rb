require 'test_helper.rb'

class AccountTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_constant :accesses
    should_act_as_paranoid
  end

  context 'Instance' do
    setup do
      @account = Account.make_unsaved(:careermee)
    end

    context 'permitted_for' do
      setup do
        @annika = User.make(:annika)
        @benny = User.make(:benny)
        @careermee = Account.make(:careermee, :user => @annika, :permission => 'Public')
        @world_dating = Account.make(:world_dating, :user => @benny, :permission => 'Public')
      end

      should 'return all public contacts' do
        assert Account.permitted_for(@annika).include?(@careermee)
        assert Account.permitted_for(@annika).include?(@world_dating)
      end

      should 'return all contacts belonging to the user' do
        @careermee.update_attributes :permission => 'Private'
        assert Account.permitted_for(@annika).include?(@careermee)
      end

      should 'NOT return private contacts belonging to another user' do
        @world_dating.update_attributes :permission => 'Private'
        assert !Account.permitted_for(@annika).include?(@world_dating)
      end

      should 'return shared contacts where the user is in the permitted users list' do
        @world_dating.update_attributes :permission => 'Shared', :permitted_user_ids => [@annika.id]
        assert Account.permitted_for(@annika).include?(@world_dating)
      end

      should 'NOT return shared contacts where the user is not in the permitted users list' do
        @world_dating.update_attributes :permission => 'Shared', :permitted_user_ids => [@world_dating.id]
        assert !Account.permitted_for(@annika).include?(@world_dating)
      end
    end

    context 'activity logging' do
      setup do
        @account.save
        @account = Account.find(@account.id)
      end

      should 'log an activity when created' do
        assert @account.activities.any? {|a| a.action == 'Created' }
      end

      should 'log an activity when updated' do
        @account.update_attributes :name => 'an update test'
        assert_equal 2, @account.activities.count
        assert @account.activities.any? {|a| a.action == 'Updated' }
      end

      should 'not log an update activity when created' do
        assert_equal 1, @account.activities.length
      end

      should 'log an activity when deleted' do
        @account.destroy
        assert @account.activities.any? {|a| a.action == 'Deleted' }
      end
    end

    should 'require at least one permitted user if permission is "Shared"' do
      @account.permission = 'Shared'
      assert !@account.valid?
      assert @account.errors.on(:permitted_user_ids)
    end

    should 'require name' do
      @account.name = nil
      assert !@account.valid?
      assert @account.errors.on(:name)
    end

    should 'require user' do
      @account.user_id = nil
      assert !@account.valid?
      assert @account.errors.on(:user_id)
    end

    should 'be valid' do
      assert @account.valid?
    end
  end
end
