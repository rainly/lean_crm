Given /^I fill in the registration form$/ do
  fill_in_registration_form
end

Given /^I have registered$/ do
  visit new_user_path
  fill_in_registration_form
  click_button 'user_submit'
end

Then /^a new user should have been created$/ do
  assert_equal 1, User.count
end

module RegistrationHelper
  def fill_in_registration_form( options = {} )
    fill_in 'user_email', :with => options[:email] || 'matt.beedle@1000jobboersen.de'
    fill_in 'user_password', :with => options[:password] || 'password'
    fill_in 'user_password_confirmation', :with => options[:password] || 'password'
  end
end

World(RegistrationHelper)
