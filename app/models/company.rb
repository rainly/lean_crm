class Company
  include MongoMapper::Document

  key :name,  String, :required => true

  has_many :users

  validates_uniqueness_of :name
end
