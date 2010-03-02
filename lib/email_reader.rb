class EmailReader

  def self.check_mail( configuration )
    imap = Net::IMAP.new(configuration.imap_host, 993, true)
    imap.login(configuration.imap_user, configuration.imap_password)
    imap.select('INBOX')
    imap.search(["NOT", "DELETED", "NOT", "SEEN"]).each do |message_id|
      email = Mail.new(imap.fetch(message_id, 'RFC822')[0].attr['RFC822'])
      imap.store(message_id, '+FLAGS', [:Deleted]) if parse_email(email)
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
      comment = Email.create! :text => get_email_content(email),
        :commentable => target, :user => user, :from_email => true,
        :subject => Mail.new(get_email_content(email)).subject || email.subject,
        :received_at => Time.zone.now, :subject => email.subject,
        :from => find_target_email(email)
      add_attachments( comment, email )
      comment
    end
    user
  rescue
    nil
  end

protected
  def self.get_email_content( email )
    if email.content_type.match(/text\/plain/)
      return email.body.to_s
    else
      email.parts.each do |part|
        return get_email_content(part)
      end
    end
  end

  def self.add_attachments( comment, email )
    email.attachments.each do |attachment|
      comment.attachments << Attachment.new(:attachment => attachment)
    end
  end

  def self.find_target( email )
    target = Lead.first(:conditions => { :email => find_target_email(email) })
    target = Contact.first(:conditions => { :email => find_target_email(email) }) unless target
    target
  end

  def self.find_target_email( email )
    mail = Mail.new(get_email_content(email))
    user = find_user_from(email)
    if not mail.from.blank? and mail.from.first != user.email
      mail.from.first
    elsif not mail.to.blank? and mail.to.first != user.email
      mail.to.first
    else
      email.to.first
    end
  end

  def self.create_contact_from( email )
    target_email = find_target_email(email)
    account = Account.create!(:name => target_email.split('@').last, :user => find_user_from(email))
    Contact.create(:email => target_email,
                   :first_name => target_email.split('@').first.split('.').first,
                   :last_name => target_email.split('@').first.split('.').last,
                   :account => account, :user => find_user_from(email))
  end

  def self.find_user_from( email )
    api_key = email.to.to_a.first.split('@').last.split('.').first
    user = User.first(:conditions => { :api_key => api_key })
    user = User.first(:email => email.from.to_a.first.strip) if user.nil?
    user
  end
end
