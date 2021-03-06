class AbstractUser
  include MongoMapper::Document

  key :username,              String
  key :encrypted_password,    String
  key :password_salt,         String
  key :reset_password_token,  String
  key :remember_token,        String
  key :remember_created_at,   Time
  key :sign_in_count,         Integer
  key :current_sign_in_at,    Time
  key :current_sign_in_ip,    String
  key :last_sign_in_ip,       String
  key :failed_attempts,       Integer
  key :confirmation_token,    String
  key :confirmed_at,          Time
  key :confirmation_sent_at,  Time
  key :reset_password_token,  String
  key :unlock_token,          String
  key :locked_at,             Time
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
end
