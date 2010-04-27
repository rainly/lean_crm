set :environment, 'production'

every 1.day, :at => '7am' do
  command "/var/www/salesflip/current/script/runner Task.daily_email"
  command "/var/www/salesflip/current/script/runner User.send_tracked_items_mail"
end

#every 10.minutes do
#  rake 'sphinx:index'
#  command 'cd /var/www/salesflip/current && ruby lib/mail_processor_control.rb restart'
#end

#every 1.hour do
#  command '/opt/mongo/bin/mongodump -d salesflip_production -o /root/backups/ && cd /root/backups/ && git add salesflip_production && git commit -m "Salesflip backup" && git push origin master'
#end
