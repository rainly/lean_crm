require 'test_helper.rb'

class AccountTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_constant :accesses
  end

  context 'Instance' do
    setup do
      @account = Account.make_unsaved(:careermee)
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
