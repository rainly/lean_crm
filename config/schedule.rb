set :environment, 'production'

every 1.day, :at => '7am' do
  command "./script/runner 'Task.daily_email'"
end
