require 'test_helper'

class IdentifierTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_key :account_identifier, :contact_identifier, :lead_identifier

    should 'be able to increment account id' do
      assert_equal 1, Identifier.next_account
      assert_equal 2, Identifier.next_account
    end

    should 'be able to increment contact id' do
      assert_equal 1, Identifier.next_contact
      assert_equal 2, Identifier.next_contact
    end

    should 'be able to increment lead id' do
      assert_equal 1, Identifier.next_lead
      assert_equal 2, Identifier.next_lead
    end
  end
end
