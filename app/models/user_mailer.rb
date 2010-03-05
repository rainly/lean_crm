class UserMailer < ActionMailer::Base

  def tracked_items_update( user )
    recipients  user.email
    from        I18n.t('emails.do_not_reply', :host => 'salesflip.com')
    subject     I18n.t('emails.tracked_items_update.subject')
    sent_on     Time.now
    body        :user => user, :items => user.tracked_items
  end
end
