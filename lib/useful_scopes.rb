module UsefulScopes
  def self.included( base )
    base.class_eval do
      named_scope :order, lambda { |order, direction| { :order => "#{order} #{direction}" } }
      named_scope :limit, lambda { |limit| { :limit => limit } }
    end
  end
end
