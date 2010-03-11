namespace(:one_time) do

  desc 'Update old style lead-contact relationship, to new style contact has_many leads'
  task :switch_contact_leads_to_has_many => :environment do
    Contact.all(:lead_id => { '$ne' => nil }).each do |contact|
      lead = Lead.first(:id => contact.lead_id)
      lead.update_attributes :contact_id => contact.id, :do_not_log => true
    end
  end
end
