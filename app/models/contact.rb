class Contact
  include MongoMapper::Document
  include HasConstant
  include ParanoidDelete
  include Permission
  include Trackable
  include Activities
  include SphinxIndex

  key :account_id,          ObjectId, :index => true
  key :user_id,             ObjectId, :required => true, :index => true
  key :lead_id,             ObjectId, :index => true
  key :assignee_id,         ObjectId, :index => true
  key :first_name,          String
  key :last_name,           String, :required => true
  key :access,              Integer
  key :title,               Integer
  key :salutation,          Integer
  key :department,          String
  key :source,              Integer
  key :email,               String
  key :alt_email,           String
  key :phone,               String
  key :mobile,              String
  key :fax,                 String
  key :website,             String
  key :linked_in,           String
  key :facebook,            String
  key :twitter,             String
  key :xing,                String
  key :address,             String
  key :born_on,             Date
  key :do_not_call,         Boolean
  key :deleted_at,          Time
  timestamps!

  sphinx_index :first_name, :last_name, :department, :email, :alt_email, :phone, :mobile,
    :fax, :website, :linked_in, :facebook, :twitter, :xing, :address

  has_constant :accesses, lambda { I18n.t('access_levels') }
  has_constant :titles, lambda { I18n.t('titles') }
  has_constant :sources,  lambda { I18n.t('lead_sources') }
  has_constant :salutations, lambda { I18n.t('salutations') }

  belongs_to :account
  belongs_to :user
  belongs_to :assignee, :class_name => 'User'
  belongs_to :lead

  has_many :tasks, :as => :asset
  has_many :comments, :as => :commentable

  def full_name
    "#{first_name} #{last_name}"
  end
  alias :name :full_name

  def listing_name
    "#{last_name}, #{first_name}".strip.gsub(/,$/, '')
  end

  def self.create_for( lead, account )
    contact = account.contacts.build :user => lead.user, :first_name => lead.first_name,
      :last_name => lead.last_name, :lead => lead, :permission => account.permission,
      :permitted_user_ids => account.permitted_user_ids
    contact.save if account.valid?
    contact
  end
end
