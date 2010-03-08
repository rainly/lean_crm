class AccountsController < InheritedResources::Base

  respond_to :html
  respond_to :xml

  def create
    create! do |success, failure|
      success.html { return_to_or_default account_path(@account) }
      success.xml { head :ok }
    end
  end

protected
  def collection
    @accounts ||= Account.permitted_for(current_user).not_deleted.order('name', 'asc').paginate(:per_page => 10, :page => params[:page] || 1)
  end

  def resource
    @account ||= Account.permitted_for(current_user).find_by_id(params[:id])
  end

  def begin_of_association_chain
    current_user
  end
end
