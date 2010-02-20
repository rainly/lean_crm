require 'test_helper.rb'

class EmailReaderTest < ActiveSupport::TestCase
  context "when email is outgoing (bcc'd)" do
    setup do
      @user = User.make(:annika)
      @email = mock()
      @email.stubs(:bcc).returns(["dropbox@#{@user.api_key}.1000jobboersen.de"])
      @email.stubs(:body).returns('This is the email body')
      @email.stubs(:attachments).returns([File.open("#{Rails.root}/test/upload-files/erich_offer.pdf")])
    end

    context 'when sent to a single receiver' do
      setup do
        @email.stubs(:to).returns(['test@test.com'])
      end

      context 'when receiver exists as a lead' do
        setup do
          @lead = Lead.make(:erich, :email => 'test@test.com')
          EmailReader.parse_email(@email)
        end

        should 'add comment to lead' do
          assert_equal 1, @lead.comments.length
        end

        should 'populate comment text from email body' do
          assert_equal @email.body, @lead.comments.first.text
        end

        should 'populate comment user from user found from email bcc address' do
          assert_equal @user, @lead.comments.first.user
        end

        should 'save attachments against comment' do
          assert_equal 1, @lead.comments.first.attachments.length
        end

        should 'mark comment as "from_email"' do
          assert @lead.comments.first.from_email
        end
      end

      context 'when receiver exists as a contact' do
        setup do
          @contact = Contact.make(:florian, :email => 'test@test.com')
          EmailReader.parse_email(@email)
        end

        should 'add comment to contact' do
          assert_equal 1, @contact.comments.length
        end
      end

      context 'when receiver does not exist' do
        should 'create contact and add comment to it' do
          EmailReader.parse_email(@email)
          assert_equal 1, Contact.count
          assert Contact.first(:conditions => { :email => @email.to })
        end
      end
    end
  end

  context 'when email is incoming (forwarded)' do
    setup do
      @message = mock()
    end

    context 'when sender exists as a lead' do
      should 'add comment to lead'

      should 'save attachments against comment'
    end

    context 'when sender exists as a contact' do
      should 'add comment to contact'
    end

    context 'when sender does not exist' do
      should 'create contact and add comment to it'
    end
  end
end
