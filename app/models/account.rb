class Account
  include MongoMapper::Document
  include HasConstant
  include ParanoidDelete
  include Permission
  include Trackable
  include Activities

  key :user_id,         ObjectId, :index => true, :required => true
  key :assignee_id,     ObjectId, :index => true
  key :name,            String, :required => true
  key :email,           String
  key :access,          Integer, :index => true
  key :website,         String
  key :phone,           String
  key :fax,             String
  key :billing_address, String
  key :shipping_address, String
  timestamps!

  has_constant :accesses, lambda { I18n.t(:access_levels) }

  belongs_to :user
  belongs_to :assignee, :class_name => 'User'
  has_many :contacts, :dependent => :nullify
  has_many :tasks, :as => :asset
  has_many :comments, :as => :commentable
end
