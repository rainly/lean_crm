namespace(:one_time) do
  task :switch_contact_leads_to_has_many => :environment do
    Contact.all(:lead_id => { '$ne' => nil }).each do |contact|
      lead = Lead.first(:id => contact.lead_id)
      lead.update_attributes :contact_id => contact.id, :do_not_log => true
    end
  end
end
