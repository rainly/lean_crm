scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 6 * * 1-5' do
  Task.daily_email
end
