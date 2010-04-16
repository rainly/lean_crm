require 'carrierwave'
require 'carrierwave/orm/mongoid'

begin
  db_config = YAML::load(File.read(File.join(Rails.root, "/config/mongodb.yml")))
rescue
  raise IOError, 'config/mongodb.yml could not be loaded'
end

CarrierWave.configure do |config|
  mongo = db_config[Rails.env]
  config.grid_fs_database = mongo['database']
  config.grid_fs_host = mongo['host'] || 'localhost'
  config.grid_fs_access_url = "gridfs"
  config.grid_fs_username = mongo['username'] if mongo['username']
  config.grid_fs_password =  mongo['password'] if mongo['password']
end

