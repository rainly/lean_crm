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
    end
  end

  context "Instance" do
    setup do
      @contact = Contact.make_unsaved(:florian)
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
