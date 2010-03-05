set :environment, 'production'

every 1.day, :at => '7am' do
  Task.email
end
