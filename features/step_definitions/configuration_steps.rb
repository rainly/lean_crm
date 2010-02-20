Given /^no configuration exists$/ do
  Configuration.delete_all
end

Then /^a configuration should have been created$/ do
  assert_equal 1, Configuration.count
end
