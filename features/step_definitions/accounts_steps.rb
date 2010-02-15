Given /^the following accounts:$/ do |accounts|
  Accounts.create!(accounts.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) accounts$/ do |pos|
  visit accounts_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following accounts:$/ do |expected_accounts_table|
  expected_accounts_table.diff!(tableish('table tr', 'td,th'))
end
