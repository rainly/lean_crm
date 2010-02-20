class Configuration
  include MongoMapper::Document

  key :imap_user,         String
  key :imap_password,     String
  key :imap_host,         String
  timestamps!
end
