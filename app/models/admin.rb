class Admin
  include MongoMapper::Document

  devise :authenticatable, :recoverable, :rememberable

  timestamps!
end
