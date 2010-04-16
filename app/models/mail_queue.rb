class MailQueue
  include Mongoid::Document
  include Mongoid::Timestamps

  field :mail
  field :status

  validates_presence_of :mail
end
