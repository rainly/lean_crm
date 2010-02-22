class Configuration
  include MongoMapper::Document

  key :company_name,      String
  key :domain_name,       String
  key :imap_user,         String
  key :imap_password,     String
  key :imap_host,         String
  timestamps!
end
