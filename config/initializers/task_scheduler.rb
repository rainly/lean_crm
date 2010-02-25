if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      scheduler = Rufus::Scheduler.start_new

      scheduler.cron '0 6 * * 1-5' do
        Task.daily_email
      end

      scheduler.every '5m' do
        EmailReader.check_mail(Configuration.first)
      end
    end
  end
end
