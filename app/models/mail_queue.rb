class MailQueue
  include MongoMapper::Document

  key :mail,      String, :required => true
  key :status,    String
  timestamps!
end
