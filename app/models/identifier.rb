class Identifier
  include Mongoid::Document

  field :account_identifier,  :type => Integer, :default => 0
  field :contact_identifier,  :type => Integer, :default => 0
  field :lead_identifier,     :type => Integer, :default => 0

  validates_presence_of :account_identifier, :contact_identifier, :lead_identifier

  def self.next_account
    Identifier.create! unless Identifier.count > 0
    identifier = first
    first.increment!(:account_identifier)
    first.account_identifier
  end

  def self.next_contact
    Identifier.create! unless Identifier.count > 0
    identifier = first
    first.increment!(:contact_identifier)
    first.contact_identifier
  end

  def self.next_lead
    Identifier.create! unless Identifier.count > 0
    identifier = first
    first.increment!(:lead_identifier)
    first.lead_identifier
  end

  def increment!( key )
    update_attributes key => self.send(key) + 1
  end
end
