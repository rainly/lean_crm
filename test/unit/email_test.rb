require 'test_helper.rb'

class EmailTest < ActiveSupport::TestCase
  context 'Class' do
    should_require_key :subject, :text, :received_at
  end

  context 'Instance' do
    setup do
      @email = Email.make_unsaved(:erich_offer_email)
    end

    should 'be valid with all required attributes' do
      assert @email.valid?
    end
  end
end
