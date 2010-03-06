class ActionMailer::Base

  def deliver_with_smtp_domain!( mail = @mail )
    ActionMailer::Base.smtp_settings.merge!({ :domain => mail.from.to_s.split('@').last }) if mail.from and not mail.from.empty?
    deliver_without_smtp_domain!(mail)
  end
  alias_method_chain :deliver!, :smtp_domain if Rails.env.production?
end
