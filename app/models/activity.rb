class Activity
  include MongoMapper::Document
  include HasConstant

  key :user_id,       ObjectId, :required => true, :index => true
  key :subject_id,    ObjectId, :required => true, :index => true
  key :subject_type,  String, :required => true, :index => true
  key :action,        Integer
  key :info,          String
  timestamps!

  belongs_to :user
  belongs_to :subject, :polymorphic => true

  validates_presence_of :subject

  has_constant :actions, lambda { I18n.t(:activity_actions) }

  def self.log( user, subject, action )
    if %w(Created Deleted).include?(action)
      create_activity(user, subject, action)
    else
      update_activity(user, subject, action)
    end
  end

  def self.create_activity( user, subject, action )
    unless subject.is_a?(Task) and action == 'Viewed'
      user.activities.create :subject => subject, :action => action
    end
  end

  def self.update_activity( user, subject, action )
    activity = Activity.first(:conditions => { :user_id => user.id, :subject_id => subject.id,
                              :subject_type => subject.class.name,
                              :action => Activity.actions.index(action) })
    if activity
      activity.update_attributes(:updated_at => Time.now)
    else
      create_activity(user, subject, action)
    end
    activity
  end
end
