class LeadsController < InheritedResources::Base
  before_filter :resource, :only => [:convert, :promote, :reject]

  respond_to :html
  respond_to :xml, :only => [:create]

  has_scope :with_status, :type => :array

  def create
    create! do |success, failure|
      success.html { redirect_to leads_path }
      success.xml { head :ok }
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
    @account, @contact = @lead.promote!(params[:account_id].blank? ? params[:account_name] : params[:account_id])
    if @account.errors.blank? and @contact.errors.blank?
      redirect_to account_path(@account)
    else
      render :action => :convert
    end
  end

  def reject
    @lead.reject!
    redirect_to leads_path
  end

protected
  def collection
    @leads ||= apply_scopes(Lead).not_deleted.permitted_for(current_user)
  end

  def resource
    @lead ||= Lead.permitted_for(current_user).find_by_id(params[:id])
  end

  def begin_of_association_chain
    current_user
  end
end
