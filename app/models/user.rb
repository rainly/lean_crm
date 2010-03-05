class User < AbstractUser

  devise :authenticatable, :confirmable, :recoverable, :rememberable, :trackable,
    :validatable, :http_authenticatable

  key :api_key, String, :index => true

  has_many :leads
  has_many :comments
  has_many :tasks
  has_many :accounts
  has_many :contacts
  has_many :activities

  before_validation_on_create :set_api_key

  def deleted_items_count
    [Lead, Contact, Account].map do |model|
      model.permitted_for(self).deleted.count
    end.inject {|sum, n| sum += n }
  end

  def full_name
    username.present? ? username : email
  end

  def recent_items
    Activity.all(:conditions => { :user_id => self.id,
                 :action => I18n.locale_around(:en) { Activity.actions.index('Viewed') } },
                 :order => 'updated_at desc', :limit => 5).map(&:subject)
  end

  def tracked_items
    (Lead.tracked_by(self) + Contact.tracked_by(self) + Account.tracked_by(self)).
      sort_by(&:created_at)
  end

  def self.send_tracked_items_mail
    User.all.each do |user|
      UserMailer.deliver_tracked_items_update(user)
    end
  end

protected
  def set_api_key
    self.api_key = UUID.new.generate
  end
end
