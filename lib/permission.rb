module Permission
  def self.included( base )
    base.class_eval do
      key :permission,          Integer, :required => true, :default => 0
      key :permitted_user_ids,  Array

      named_scope :permitted_for, lambda {|user| { :conditions => {
        '$where' => <<-JAVASCRIPT
        this.user_id == '#{user.id}' || this.permission == '#{Contact.permissions.index('Public')}' ||
        (this.permission == '#{Contact.permissions.index('Shared')}' && this.permitted_user_ids[0] == '#{user.id}')
        JAVASCRIPT
      } } }

      validate :require_permitted_users

      has_constant :permissions, lambda { I18n.t('permissions') }
    end
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def require_permitted_users
      if I18n.locale_around(:en) { permission_is?('Shared') } and permitted_user_ids.length < 1
        errors.add :permitted_user_ids, I18n.t('activerecord.errors.messages.blank')
      end
    end
  end
end
