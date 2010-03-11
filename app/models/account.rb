class Account
  include MongoMapper::Document
  include HasConstant
  include ParanoidDelete
  include Permission
  include Trackable
  include Activities
  include SphinxIndex

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

  sphinx_index :name, :email, :phone, :website, :fax

  def self.named(query)
    self.all( :name => /^#{query}.*/i )
  end

  def self.find_or_create_for( object, name_or_id, options = {} )
    account = Account.find_by_id(Mongo::ObjectID.from_string(name_or_id.to_s))
  rescue Mongo::InvalidObjectID => e
    account = Account.find_by_name(name_or_id)
    account = create_for(object, name_or_id, options) unless account
    account
  end

  def self.create_for( object, name, options = {} )
    if options[:permission] == 'Object'
      permission = object.permission
      permitted = object.permitted_user_ids
    else
      permission = options[:permission]
      permitted = options[:permitted_user_ids]
    end
    account = object.updater_or_user.accounts.create :permission => permission,
      :name => name, :permitted_user_ids => permitted
  end
end
