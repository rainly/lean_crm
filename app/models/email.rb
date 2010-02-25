class Email < Comment
  key :subject,       String, :required => true
  key :received_at,   Time, :required => true
end
