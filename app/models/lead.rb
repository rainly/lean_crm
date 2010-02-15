class Lead
  include MongoMapper::Document
  include HasConstant

  key :user_id,       ObjectId, :required => true, :index => true
  key :first_name,    String, :required => true
  key :last_name,     String, :required => true
  key :email,         String
  key :phone,         String
  key :status,        Integer
  key :source,        Integer
  key :rating,        Integer
  key :campaign_id,   ObjectId, :index => true
  key :notes,         String

  key :title,         Integer
  key :salutation,    Integer
  key :company,       String
  key :alternative_email, String
  key :mobile,        String
  key :address,       String
  key :referred_by,   String
  key :do_not_call,   Boolean

  key :website,       String
  key :twitter,       String
  key :linked_in,     String
  key :facebook,      String
  key :xing,          String
  timestamps!

  belongs_to :user
  has_many :comments, :as => :commentable
  has_many :tasks, :as => :asset

  before_validation_on_create :set_initial_state

  has_constant :titles, lambda { I18n.t('titles') }
  has_constant :statuses, lambda { I18n.t('lead_statuses') }
  has_constant :sources, lambda { I18n.t('lead_sources') }
  has_constant :salutations, lambda { I18n.t('salutations') }

  named_scope :with_status, lambda {|statuses| { :conditions => {
    :status => statuses.map {|status| Lead.statuses.index(status) } } } }

  def full_name
    "#{first_name} #{last_name}"
  end

  def promote( account_name )
    account = self.user.accounts.find_or_create_by_name(account_name)
    contact = Contact.create_for(self, account)
    I18n.locale_around(:en) { update_attributes :status => 'Converted' }
    return account, contact
  end

protected
  def set_initial_state
    I18n.locale_around(:en) { self.status = 'New' unless self.status }
  end
end
