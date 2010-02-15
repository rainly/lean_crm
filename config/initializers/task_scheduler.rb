scheduler = Rufus::Scheduler.start_new

scheduler.every '1d', :first_at => Chronic.parse('tomorrow at 6:00') do
  Task.daily_email unless %w(6 0).include?(Time.zone.now.stftime("%w"))
end
