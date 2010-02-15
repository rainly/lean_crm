require 'test_helper.rb'

class UserTest < ActiveSupport::TestCase
  context 'Instance' do
    setup do
      @user = User.make_unsaved(:annika)
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
