require 'test_helper.rb'

class ContactTest < ActiveSupport::TestCase
  context "Class" do
    should_have_constant :accesses, :titles

    context 'create_for' do
      setup do
        @account = Account.make(:careermee)
        @lead = Lead.make(:call_erich, :user => @account.user)
      end

      should 'create a contact from the supplied lead and account' do
        Contact.create_for(@lead, @account)
        assert_equal 1, Contact.count
        assert Contact.find_by_first_name_and_last_name(@lead.first_name, @lead.last_name)
        assert_equal 1, @account.contacts.count
      end

      should 'assign lead to contact' do
        contact = Contact.create_for(@lead, @account)
        assert_equal @lead, contact.lead
      end
    end
  end

  context "Instance" do
    setup do
      @contact = Contact.make_unsaved(:florian)
    end

    context 'activity logging' do
      setup do
        @contact.save!
        @contact = Contact.find(@contact.id)
      end

      should 'log an activity when created' do
        assert @contact.activities.any? {|a| a.action == 'Created' }
      end

      should 'log an activity when updated' do
        @contact.update_attributes :first_name => 'test'
        assert @contact.activities.any? {|a| a.action == 'Updated' }
      end

      should 'not log an update activity when created' do
        assert_equal 1, @contact.activities.count
      end
    end

    should 'have full name' do
      assert_equal 'Florian Behn', @contact.full_name
    end

    should 'alias full_name to name' do
      assert_equal @contact.name, @contact.full_name
    end

    should 'require first name' do
      @contact.first_name = nil
      assert !@contact.valid?
      assert @contact.errors.on(:first_name)
    end

    should 'require last name' do
      @contact.last_name = nil
      assert !@contact.valid?
      assert @contact.errors.on(:last_name)
    end

    should 'be valid' do
      assert @contact.valid?
    end
  end
end
