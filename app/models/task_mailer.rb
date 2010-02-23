class TaskMailer < ActionMailer::Base

  def assignment_notification( task )
    recipients    task.assignee.email
    from          I18n.t('emails.do_not_reply', :host => Configuration.first.domain_name)
    subject       I18n.t('emails.task_reassigned.subject')
    body          :url => task_url(task)
    sent_on       Time.now
  end

  def daily_task_summary( user, tasks )
    recipients    user.email
    from          I18n.t('emails.do_not_reply', :host => Configuration.first.domain_name)
    subject       I18n.t('emails.daily_task_summary.subject')
    body          :tasks => tasks
    sent_on       Time.now
  end
end
