# WTF, shouldn't this be defined by pickle?!
Given /^an activity exists with subject: erich, action: "([^\"]*)", user: annika$/ do |arg1|
  Activity.make(:subject => model!('lead'), :user => model!('annika'), :action => arg1)
end
