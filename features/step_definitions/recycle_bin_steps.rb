Given /^#{capture_model} has been deleted$/ do |item|
  m = model!(item)
  m.destroy
end
