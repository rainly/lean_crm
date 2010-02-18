require 'test_helper.rb'

class LeadTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_constant :titles, :statuses, :sources, :salutations
  end

  context 'Named Scopes' do
    context 'with_status' do
      setup do
        @new = Lead.make(:erich)
        @rejected = Lead.make(:markus)
      end

      should 'return leads with any of the supplied statuses' do
        assert_equal [@new], Lead.with_status('New')
        assert_equal [@rejected], Lead.with_status('Rejected')
        assert_equal [@new, @rejected], Lead.with_status(['New', 'Rejected'])
      end
    end
  end

  context 'Instance' do
    setup do
      @lead = Lead.make_unsaved(:erich)
    end

    context 'activity logging' do
      setup do
        @lead.save!
      end

      should 'log an activity when created' do
        assert_equal 1, @lead.activities.count
        assert @lead.activities.any? {|a| a.action == 'Created' }
      end

      should 'log an activity when updated' do
        @lead = Lead.find_by_id(@lead.id)
        @lead.update_attributes :first_name => 'test'
        assert @lead.activities.any? {|a| a.action == 'Updated' }
      end

      should 'log an activity when converted' do
        @lead = Lead.find_by_id(@lead.id)
        @lead.promote!('A new company')
        assert @lead.activities.any? {|a| a.action == 'Converted' }
      end

      should 'not log an update activity when converted' do
        @lead = Lead.find(@lead.id)
        @lead.promote!('A company')
        assert !@lead.activities.any? {|a| a.action == 'Updated' }
      end

      should 'log an activity when rejected' do
        @lead = Lead.find(@lead.id)
        @lead.reject!
        assert @lead.activities.any? {|a| a.action == 'Rejected' }
      end

      should 'not log an update activity when rejected' do
        @lead = Lead.find(@lead.id)
        @lead.reject!
        assert !@lead.activities.any? {|a| a.action == 'Updated' }
      end
    end

    context 'promote' do
      should 'create a new account and contact when a new account is specified' do
        @lead.promote!('Super duper company')
        assert account = Account.find_by_name('Super duper company')
        assert account.contacts.any? {|c| c.first_name == @lead.first_name &&
          c.last_name == @lead.last_name }
      end

      should 'change the lead status to "converted"' do
        @lead.promote!('A company')
        assert @lead.status_is?('Converted')
      end

      should 'assign lead to contact' do
        @lead.promote!('company name')
        assert_equal @lead, Account.find_by_name('company name').contacts.first.lead
      end
    end

    should 'require first name' do
      @lead.first_name = nil
      assert !@lead.valid?
      assert @lead.errors.on(:first_name)
    end

    should 'require last name' do
      @lead.last_name = nil
      assert !@lead.valid?
      assert @lead.errors.on(:last_name)
    end

    should 'require user id' do
      @lead.user_id = nil
      assert !@lead.valid?
      assert @lead.errors.on(:user_id)
    end

    should 'be valid' do
      assert @lead.valid?
    end

    should 'have full_name' do
      assert_equal 'Erich Feldmeier', @lead.full_name
    end

    should 'alias full_name to name' do
      assert_equal @lead.name, @lead.full_name
    end

    should 'start with status "New"' do
      @lead.save
      assert_equal 'New', @lead.status
    end

    should 'start with different status if one is specified' do
      @lead.status = 'Rejected'
      @lead.save
      assert_equal 'Rejected', @lead.status
    end
  end
end
