require 'test_helper.rb'

class LeadTest < ActiveSupport::TestCase
  context 'Class' do
    should_have_constant :titles, :statuses, :sources, :salutations, :permissions
    should_act_as_paranoid
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

    context 'not_deleted' do
      setup do
        @new = Lead.make(:erich)
        @rejected = Lead.make(:markus)
        @deleted = Lead.make(:kerstin)
      end

      should 'return all leads which are not deleted' do
        assert_equal 2, Lead.not_deleted.count
        assert !Lead.not_deleted.include?(@deleted)
      end
    end

    context 'permitted_for' do
      setup do
        @erich = Lead.make(:erich, :permission => 'Public')
        @markus = Lead.make(:markus, :permission => 'Public')
      end

      should 'return all public leads' do
        assert Lead.permitted_for(@erich.user).include?(@erich)
        assert Lead.permitted_for(@erich.user).include?(@markus)
      end

      should 'return all leads belonging to the user' do
        @erich.update_attributes :permission => 'Private'
        assert Lead.permitted_for(@erich.user).include?(@erich)
      end

      should 'NOT return private leads belonging to another user' do
        @markus.update_attributes :permission => 'Private'
        assert !Lead.permitted_for(@erich.user).include?(@markus)
      end

      should 'return shared leads where the user is in the permitted user list' do
        @markus.update_attributes :permission => 'Shared', :permitted_user_ids => [@erich.user.id]
        assert Lead.permitted_for(@erich.user).include?(@markus)
      end

      should 'NOT return shared leads where the user is not in the permitted user list' do
        @markus.update_attributes :permission => 'Shared', :permitted_user_ids => [@markus.user.id]
        assert !Lead.permitted_for(@erich.user).include?(@markus)
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

      should 'log an activity when destroyed' do
        @lead = Lead.find_by_id(@lead.id)
        @lead.destroy
        assert @lead.activities.any? {|a| a.action == 'Deleted' }
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

      should 'be able to specify a "Private" permission level' do
        @lead.promote!('A company', :permission => 'Private')
        assert_equal 'Private', Account.first.permission
        assert_equal 'Private', Contact.first.permission
      end

      should 'be able to specify a "Shared" permission level' do
        @lead.promote!('A company', :permission => 'Shared', :permitted_user_ids => [@lead.user_id])
        assert_equal 'Shared', Account.first.permission
        assert_equal [@lead.user_id], Account.first.permitted_user_ids
        assert_equal 'Shared', Contact.first.permission
        assert_equal [@lead.user_id], Contact.first.permitted_user_ids
      end

      should 'be able to use leads permission level' do
        @lead.update_attributes :permission => 'Shared', :permitted_user_ids => [@lead.user_id]
        @lead.promote!('A company', :permission => 'Lead')
        assert_equal @lead.permission, Account.first.permission
        assert_equal @lead.permitted_user_ids, Account.first.permitted_user_ids
        assert_equal @lead.permission, Contact.first.permission
        assert_equal @lead.permitted_user_ids, Contact.first.permitted_user_ids
      end

      should 'return an invalid account without an account name' do
        account, contact = @lead.promote!('')
        assert !account.errors.blank?
      end

      should 'not create a contact when account is invalid' do
        @lead.promote!('')
        assert_equal 0, Contact.count
      end

      should 'not convert lead when account is invalid' do
        @lead.promote!('')
        assert_equal 'New', @lead.reload.status
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

    should 'require at least one permitted user if permission is "Shared"' do
      @lead.permission = 'Shared'
      assert !@lead.valid?
      assert @lead.errors.on(:permitted_user_ids)
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
