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
