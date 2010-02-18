namespace(:lean) do
  task :setup => :environment do
    Admin.create! :email => 'matt.beedle@1000jobboersen.de', :password => 'password',
      :password_confirmation => 'password'
    Configuration.create!
  end
end
