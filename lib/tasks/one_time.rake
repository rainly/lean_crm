namespace(:one_time) do

  desc 'Update old style lead-contact relationship, to new style contact has_many leads'
  task :switch_contact_leads_to_has_many => :environment do
    Contact.all(:lead_id => { '$ne' => nil }).each do |contact|
      lead = Lead.first(:id => contact.lead_id)
      lead.update_attributes :contact_id => contact.id, :do_not_log => true
    end
  end

  desc 'Transfer abstract users'
  task :transfer_abstract_users => :environment do
    AbstractUser.all.each do |abstract_user|
      user = User.new(abstract_user.attributes)
      user.save(false)
    end
  end

  desc 'Add company scoping (1000JobBoersen.de)'
  task :add_company => :environment do
    c = Company.find_or_create_by_name('1000JobBoersen.de')
    User.all.each do |user|
      user.update_attributes :company_id => c.id
    end
  end
end
