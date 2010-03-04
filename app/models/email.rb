class Email < Comment
  key :received_at,   Time, :required => true
  key :from,          String, :required => true

  validates_presence_of :subject
end
