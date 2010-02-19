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

Then /^a created activity should exist for lead with first_name "([^\"]*)"$/ do |first_name|
  assert Activity.first(:conditions => { :action => Activity.actions.index('Created') }).
    subject.first_name == first_name
end

Then /^an updated activity should exist for lead with first_name "([^\"]*)"$/ do |first_name|
  assert Activity.first(:conditions => { :action => Activity.actions.index('Updated') }).
    subject.first_name == first_name
end

Then /^a view activity should have been created for lead with first_name "([^\"]*)"$/ do |first_name|
  assert Activity.first(:conditions => { :action => Activity.actions.index('Viewed') }).
    subject.first_name == first_name
end

Then /^a new "([^\"]*)" activity should have been created for "([^\"]*)" with "([^\"]*)" "([^\"]*)"$/ do |action, model, field, value|
  assert Activity.first(:conditions => { :action => Activity.actions.index(action),
                        :subject_type => model }).subject.send(field) == value
end

Then /^lead "([^\"]*)" should have been deleted$/ do |lead|
  l = Lead.first
  assert l.deleted_at
end

When /^I POST attributes for lead: "([^\"]*)" to (.+)$/ do |blueprint_name, page_name|
  annika = model!('annika')
  attributes = Lead.plan(blueprint_name.to_sym).delete_if {|k,v| k.to_s == 'user_id' }.to_xml(:root => 'lead')
  send(:post, "#{path_to(page_name)}.xml", attributes,
       { 'Authorization' => 'Basic ' + ["#{annika.email}:password"].pack('m').delete("\r\n"),
         'Content-Type' => 'application/xml' })
end
