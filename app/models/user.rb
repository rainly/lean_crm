class User < AbstractUser

  devise :authenticatable, :recoverable, :rememberable

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
                 :order => 'updated_at desc', :limit => 5).
                 map(&:subject)
  end

protected
  def set_api_key
    self.api_key = UUID.new.generate
  end
end
