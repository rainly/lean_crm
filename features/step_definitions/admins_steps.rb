Given /^I login as an administrator: "([^\"]*)"$/ do |user|
  u = Admin.first
  visit new_admin_session_path
  fill_in 'admin_email', :with => u.email
  fill_in 'admin_password', :with => 'password'
  click_button 'admin_submit'
end
