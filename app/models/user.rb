class User < AbstractUser

  devise :authenticatable, :confirmable, :recoverable, :rememberable, :trackable,
    :validatable, :http_authenticatable

  key :api_key,               String

  has_many :leads
  has_many :comments
  has_many :tasks
  has_many :accounts
  has_many :contacts
  has_many :activities

  before_validation_on_create :set_api_key

  def recent_items
    Activity.all(:conditions => { :user_id => self.id,
                 :action => I18n.locale_around(:en) { Activity.actions.index('Viewed') } },
                 :order => 'updated_at desc', :limit => 5).map(&:subject)
  end

  def tracked_items
    (Lead.tracked_by(self) + Contact.tracked_by(self) + Account.tracked_by(self)).
      sort_by(&:created_at)
  end

protected
  def set_api_key
    self.api_key = UUID.new.generate
  end
end
