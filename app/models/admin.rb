class Admin
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :recoverable, :rememberable
end
