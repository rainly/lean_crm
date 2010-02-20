include MongoMapper

db_config = YAML::load(File.read(File.join(Rails.root, "/config/mongodb.yml")))

if db_config[Rails.env] && db_config[Rails.env]['adapter'] == 'mongodb'
  mongo = db_config[Rails.env]
  MongoMapper.connection = Mongo::Connection.new(mongo['host'] || 'localhost',
                                                 mongo['port'] || 27017,
                                                 :logger => Rails.logger)
  MongoMapper.database = mongo['database']

  if mongo['username'] && mongo['password']
    MongoMapper.database.authenticate(mongo['username'], mongo['password'])
  end
end

ActionController::Base.rescue_responses['MongoMapper::DocumentNotFound'] = :not_found

require 'carrierwave'
require 'carrierwave/orm/mongomapper'

CarrierWave.configure do |config|
  mongo = db_config[Rails.env]
  config.grid_fs_database = mongo['database']
  config.grid_fs_host = mongo['host'] || 'localhost'
  config.grid_fs_access_url = "gridfs"
  config.grid_fs_username = mongo['username'] if mongo['username']
  config.grid_fs_password =  mongo['password'] if mongo['password']
end
