module Activities
  def self.included( base )
    base.class_eval do
      has_many :activities, :as => :subject, :dependent => :destroy

      after_create  :log_creation
      after_update  :log_update
    end
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def log_creation
      Activity.log(self.user, self, 'Created')
      @recently_created = true
    end

    def log_update
      case
      when @recently_destroyed
        Activity.log(self.user, self, 'Deleted')
      when @recently_restored
        Activity.log(self.user, self, 'Restored')
      else
        Activity.log(self.user, self, 'Updated')
      end
    end

    def related_activities
      conditions = ["(this.subject_type == 'Lead' && this.subject_id == '#{self.id}')"]
      conditions << "((this.subject_type == 'Comment' || this.subject_type == 'Email') && '#{comments.map(&:id)}'.indexOf(this.subject_id) != -1)"
      conditions << "(this.subject_type == 'Task' && '#{tasks.map(&:id)}'.indexOf(this.subject_id) != -1)"
      Activity.scoped(:conditions => { '$where' => conditions.join(' || ') })
    end
  end
end
