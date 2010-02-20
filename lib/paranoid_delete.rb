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
  end
end
