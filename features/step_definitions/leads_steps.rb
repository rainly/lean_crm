Given /^I am registered and logged in as #{capture_model}$/ do |user|
  visit new_user_path
  fill_in_registration_form(:email => User.plan(user.to_sym)[:email])
  click_button 'user_submit'
  visit new_user_session_path
  fill_in_login_form(:email => User.plan(user.to_sym)[:email])
  click_button 'user_submit'
  store_model('user', 'annika', User.last(:order => 'created_at'))
end

Then /^a task should have been created$/ do
  assert_equal 1, Task.count
end
