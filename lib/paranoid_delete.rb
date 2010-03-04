module ParanoidDelete
  def self.included( base )
    base.send(:include, InstanceMethods)
    base.key :deleted_at, Time
    base.class_eval do
      alias_method_chain :destroy, :paranoid
    end
    base.named_scope :not_deleted, :conditions => { :deleted_at => nil }
  end

  module InstanceMethods
    def destroy_with_paranoid
      @recently_destroyed = true
      update_attributes :deleted_at => Time.now
    end

    def deleted_at=( value )
      original_value = self.deleted_at
      self[:deleted_at] = value
      @recently_restored = true if !original_value.nil? && self.deleted_at.nil?
    end
  end
end
