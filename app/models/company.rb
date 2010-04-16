class Company
  include Mongoid::Document

  key :name

  has_many_related :users

  validates_uniqueness_of :name
end
