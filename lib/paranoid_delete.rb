module ParanoidDelete
  def self.included( base )
    base.send(:include, InstanceMethods)
    base.key :deleted_at, Time, :index => true
    base.class_eval do
      alias_method_chain :destroy, :paranoid
    end
    base.named_scope :not_deleted, :conditions => { :deleted_at => nil }
    base.named_scope :deleted, :conditions => { :deleted_at => { '$ne' => nil } }
  end

  module InstanceMethods
    def destroy_with_paranoid
      @recently_destroyed = true
      update_attributes :deleted_at => Time.now
    end
    
    def destroy
      comments.all.each(&:destroy_without_paranoid) if self.respond_to?(:comments)
      super
    end

    def deleted_at=( value )
      original_value = self.deleted_at
      self[:deleted_at] = value
      @recently_restored = true if !original_value.nil? && self.deleted_at.nil?
    end
  end
end
