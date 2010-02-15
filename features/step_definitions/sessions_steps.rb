Given /^I fill in the login form$/ do
  fill_in_login_form
end

Given /^I am logged in$/ do
  visit new_user_session_path
  fill_in_login_form
  click_button 'user_submit'
end

module SessionHelper
  def fill_in_login_form( options = {} )
    fill_in 'user_email', :with => options[:email] || 'matt.beedle@1000jobboersen.de'
    fill_in 'user_password', :with => 'password'
  end
end

World(SessionHelper)
