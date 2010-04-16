class Email < Comment
  field :received_at,   :type => Time
  field :from

  validates_presence_of :subject, :received_at, :from

  alias :name :subject
end
