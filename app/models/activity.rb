class Activity
  include MongoMapper::Document
  include HasConstant

  key :user_id,       ObjectId, :required => true, :index => true
  key :subject_id,    ObjectId, :index => true
  key :subject_type,  String, :index => true
  key :action,        Integer
  key :info,          String
  key :notified_user_ids,  Array, :index => true
  timestamps!

  belongs_to :user
  belongs_to :subject, :polymorphic => true

  validates_presence_of :subject

  named_scope :already_notified, lambda {|user| {
    :conditions => { :notified_user_ids => user.id } } }
  named_scope :not_notified, lambda { |user| {
    :conditions => { :notified_user_ids => { '$ne' => user.id } } } }

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
      activity.update_attributes(:updated_at => Time.zone.now, :user_id => user.id)
    else
      create_activity(user, subject, action)
    end
    activity
  end
end

module MongoMapper
  module Plugins
    module NamedScope
      class Scope
        def visible_to( user )
          delete_if do |activity|
            (activity.subject.permission_is?('Private') and activity.subject.user != user) or
            (activity.subject.permission_is?('Shared') and not
             activity.subject.permitted_user_ids.include?(user.id) and
             activity.subject.user != user)
          end
        end

        def not_restored
          delete_if { |activity| activity.subject.deleted_at.nil? }
        end
      end
    end
  end
end
