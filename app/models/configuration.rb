class Configuration
  include Mongoid::Document
  include Mongoid::Timestamps

  field :company_name
  field :domain_name
  field :imap_user
  field :imap_password
  field :imap_host
end
