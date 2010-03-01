Given /^I am registered and logged in as #{capture_model}$/ do |user|
  visit new_user_path
  fill_in_registration_form(:email => User.plan(user.to_sym)[:email])
  click_button 'user_submit'
  visit new_user_session_path
  fill_in_login_form(:email => User.plan(user.to_sym)[:email])
  click_button 'user_submit'
  store_model('user', user, User.last(:order => 'created_at'))
end

Given /^I login as #{capture_model}$/ do |user|
  m = model!(user)
  visit new_user_session_path
  fill_in_login_form(:email => m.email)
  click_button 'user_submit'
end

Given /^erich is shared with annika$/ do
  lead = Lead.find_by_first_name('Erich')
  user = User.find_by_email('annika.fleischer@1000jobboersen.de')
  lead.update_attributes :permitted_user_ids => [user.id], :permission => 'Shared'
end

Given /^markus is not shared with annika$/ do
  lead = Lead.find_by_first_name('Markus')
  lead.update_attributes :permitted_user_ids => [lead.user_id], :permission => 'Shared'
end

Then /^#{capture_model} should be observing the #{capture_model}$/ do |user, trackable|
  t = model!(trackable)
  u = model!(user)
  assert t.tracker_ids.include?(u.id)
end

Then /^#{capture_model} should not be observing the #{capture_model}$/ do |user, trackable|
  t = model!(trackable)
  u = model!(user)
  assert !t.tracker_ids.include?(u.id)
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
