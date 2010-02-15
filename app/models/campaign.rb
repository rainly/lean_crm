class Campaign
  include MongoMapper::Document
  include HasConstant

  key :name,        String, :index => true
  key :start_date,  Date
  key :end_date,    Date
  key :status,      Integer, :index => true

  key :number_of_leads,       Integer
  key :conversion_percentage, Float
  key :target_revenue,        Float
  key :budget,                Float
  key :objectives,            String

  has_constant :statuses, lambda { I18n.t(:statuses) }
end
