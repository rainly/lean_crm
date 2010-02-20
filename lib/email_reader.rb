class EmailReader

  def self.check_mail( configuration )
    imap = Net::IMAP.new(configuration.imap_host, 993, true)
    imap.login(configuration.imap_user, configuration.imap_password)
    imap.select('INBOX')
    imap.search(["NOT", "DELETED", "NOT", "SEEN"]).each do |message_id|
      email = TMail::Mail.parse(imap.fetch(message_id, 'RFC822')[0].attr['RFC822'])
      if parse_email(email)
        imap.store(message_id, '+FLAGS', [:Deleted])
      end
    end
    imap.expunge
    imap.logout
    imap.disconnect
  end

  def self.parse_email( email )
    if user = find_user_from(email)
      unless target = find_target(email)
        target = create_contact_from(email)
      end
      comment = target.comments.create! :text => email.body, :commentable => target,
        :user => user, :from_email => true
      add_attachments( comment, email )
      comment
    end
  end

protected
  def self.add_attachments( comment, email )
    email.attachments.each do |attachment|
      comment.attachments << Attachment.new(:attachment => attachment)
    end
  end

  def self.find_target( email )
    target = Lead.first(:conditions => { :email => email.to.first })
    target = Contact.first(:conditions => { :email => email.to.first }) unless target
    target
  end

  def self.create_contact_from( email )
    account = Account.create(:name => email.to.split('@').last)
    Contact.create(:email => email.to.first,
                   :first_name => email.to.first.split('@').first.split('.').first,
                   :last_name => email.to.first.split('@').first.split('.').last,
                   :account => account, :user => find_user_from(email))
  end

  def self.find_user_from( email )
    api_key = email.bcc.to_a.first.split('@').last.split('.').first
    User.first(:conditions => { :api_key => api_key })
  end
end
