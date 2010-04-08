class Admin
  include MongoMapper::Document

  devise :database_authenticatable, :recoverable, :rememberable

  timestamps!
end
