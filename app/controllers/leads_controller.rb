class LeadsController < InheritedResources::Base

  before_filter :resource, :only => [:convert, :promote]

  has_scope :with_status, :type => :array

  def create
    create! do |success, failure|
      success.html { redirect_to leads_path }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to leads_path }
    end
  end

  def convert
    @account = current_user.accounts.new(:name => @lead.company)
  end

  def promote
    @account, @contact = @lead.promote(params[:account_name])
    redirect_to account_path(@account)
  end

protected
  def collection
    @leads ||= apply_scopes(Lead).scoped(:conditions => { :user_id => current_user.id })
  end

  def begin_of_association_chain
    current_user
  end
end
