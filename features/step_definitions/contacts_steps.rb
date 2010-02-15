Given /^the following contacts:$/ do |contacts|
  Contacts.create!(contacts.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) contacts$/ do |pos|
  visit contacts_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following contacts:$/ do |expected_contacts_table|
  expected_contacts_table.diff!(tableish('table tr', 'td,th'))
end

Then /^#{capture_model} should have a contact with first_name: "(.+)"$/ do |target, first_name|
  assert model!(target).contacts.find_by_first_name(first_name)
end
