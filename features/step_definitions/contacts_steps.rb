Given /^florian is shared with annika$/ do
  u = User.find_by_email('annika.fleischer@1000jobboersen.de')
  c = Contact.find_by_first_name('Florian')
  c.update_attributes :permission => 'Shared', :permitted_user_ids => [u.id]
end

Then /^#{capture_model} should have a contact with first_name: "(.+)"$/ do |target, first_name|
  assert model!(target).contacts.find_by_first_name(first_name)
end
