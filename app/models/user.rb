class User
  include MongoMapper::Document

  devise :authenticatable, :recoverable, :rememberable

  key :username,              String
  key :encrypted_password,    String
  key :password_salt,         String
  key :reset_password_token,  String
  key :remember_token,        String
  key :remember_created_at,   Time
  key :sign_in_count,         Integer
  key :current_sign_in_at,    Time
  key :current_sign_in_ip,    String

  key :api_key,               String
  timestamps!

  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i

  validates_length_of :email, :within => 6..100, :allow_blank => true
  validates_format_of :email, :with => RegEmailOk, :allow_blank => true
  validates_presence_of :email
  PasswordRequired = Proc.new {|i| i.password_salt.blank? }
  validates_presence_of :password, :if => PasswordRequired
  validates_confirmation_of :password

  has_many :leads
  has_many :comments
  has_many :tasks
  has_many :accounts
  has_many :contacts
  has_many :activities

  before_validation_on_create :set_api_key

protected
  def set_api_key
    self.api_key = UUID.new.generate
  end
end
