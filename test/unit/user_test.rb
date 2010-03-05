require 'test_helper.rb'

class UserTest < ActiveSupport::TestCase
  context 'Instance' do
    setup do
      @user = User.make_unsaved(:annika)
    end

    context 'deleted_items_count' do
      setup do
        @lead = Lead.make
        @contact = Contact.make
        @account = Account.make
      end

      should 'return a count of all deleted accounts, contacts and leads' do
        assert_equal 0, @user.deleted_items_count
        @lead.destroy
        assert_equal 1, @user.deleted_items_count
        @contact.destroy
        assert_equal 2, @user.deleted_items_count
        @account.destroy
        assert_equal 3, @user.deleted_items_count
      end

      should 'not count permanently deleted items' do
        @lead.destroy
        @lead.destroy_without_paranoid
        assert_equal 0, @user.deleted_items_count
      end
    end

    context 'full_name' do
      should 'return username if present' do
        @user.update_attributes(:username => 'annie')
        @user.save!
        assert_equal @user.full_name, "annie"
      end

      should 'return email if username is not present' do
        @user.save!
        assert_equal @user.full_name, "annika.fleischer1@1000jobboersen.de"
      end
    end

    context 'tracked_items' do
      setup do
        @user.save!
      end

      should 'return all tracked leads' do
        lead = Lead.make(:erich, :tracker_ids => [@user.id])
        assert @user.tracked_items.include?(lead)
      end

      should 'return all tracked contacts' do
        contact = Contact.make(:florian, :tracker_ids => [@user.id])
        assert @user.tracked_items.include?(contact)
      end

      should 'return all tracked accounts' do
        account = Account.make(:careermee, :tracker_ids => [@user.id])
        assert @user.tracked_items.include?(account)
      end
    end

    context 'recent_items' do
      should 'return recently viewed items' do
        @lead = Lead.make
        Activity.log(@user, @lead, 'Viewed')
        assert @user.recent_items.include?(@lead)
      end

      should 'order items by when they where viewed' do
        @lead = Lead.make
        @contact = Contact.make
        @contact2 = Contact.make
        Activity.log(@user, @lead, 'Viewed')
        Activity.log(@user, @contact2, 'Viewed')
        Activity.log(@user, @contact, 'Viewed')
        assert_equal [@contact, @contact2, @lead], @user.recent_items
      end

      should 'return a maximum of 5 items' do
        6.times do
          @lead = Lead.make
          Activity.log(@user, @lead, 'Viewed')
        end
        assert_equal 5, @user.recent_items.length
      end
    end

    should 'have uuid after creation' do
      @user.save!
      assert !@user.api_key.blank?
    end

    should 'be valid' do
      assert @user.valid?
    end

    should 'not be valid with email less than 6 characters long' do
      @user.email = 'a@b.c'
      assert !@user.valid?
      assert @user.errors.on(:email)
    end

    should 'not be valid with email more than 100 characters long' do
      @user.email = 101.times.map { 'a' }.join('')
      assert !@user.valid?
      assert @user.errors.on(:email)
    end

    should 'not be valid with invalid email' do
      @user.email = 'matt'
      assert !@user.valid?
      assert @user.errors.on(:email)
    end

    should 'not be valid without email' do
      @user.email = nil
      assert !@user.valid?
      assert @user.errors.on(:email)
    end

    context 'when new record' do
      should 'not be valid without password' do
        @user.password = nil
        assert !@user.valid?
        assert @user.errors.on(:password)
      end

      should 'not be valid without password confirmation' do
        @user.password_confirmation = nil
        assert !@user.valid?
        assert @user.errors.on(:password)
      end
    end
  end
end
