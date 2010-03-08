class UserMailer < ActionMailer::Base

  def tracked_items_update( user )
    recipients  user.email
    from        I18n.t('emails.do_not_reply', :host => 'salesflip.com')
    subject     I18n.t('emails.tracked_items_update.subject', :date => Date.today.to_s(:long))
    sent_on     Time.now
    body        :user => user, :items => user.tracked_items
  end

  def lead_assignment_notification( lead )
    recipients  lead.assignee.email
    from        I18n.t('emails.do_not_reply', :host => 'salesflip.com')
    subject     I18n.t('emails.lead_assignment.subject')
    sent_on     Time.now
    body        :lead => lead
  end
end
