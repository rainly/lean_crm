Given /^careermee is shared with annika$/ do
  c = Account.find_by_name('CareerMee')
  a = User.find_by_email('annika.fleischer@1000jobboersen.de')
  c.update_attributes :permission => 'Shared', :permitted_user_ids => [a.id]
end
