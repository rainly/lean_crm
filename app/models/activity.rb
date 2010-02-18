class Activity
  include MongoMapper::Document
  include HasConstant

  key :user_id,       ObjectId, :required => true, :index => true
  key :subject_id,    ObjectId, :required => true, :index => true
  key :subject_type,  String, :required => true, :index => true
  key :action,        Integer
  key :info,          String

  belongs_to :user
  belongs_to :subject, :polymorphic => true

  validates_presence_of :subject

  has_constant :actions, lambda { I18n.t(:activity_actions) }

  def self.log( user, subject, action )
    user.activities.create :subject => subject, :action => action
  end
end
