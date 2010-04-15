class Identifier
  include MongoMapper::Document

  key :account_identifier,  Integer, :required => true, :default => 0
  key :contact_identifier,  Integer, :required => true, :default => 0
  key :lead_identifier,     Integer, :required => true, :default => 0

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
