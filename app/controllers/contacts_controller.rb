class ContactsController < InheritedResources::Base

  respond_to :html
  respond_to :xml

  def create
    create! do |success, failure|
      success.xml { head :ok }
    end
  end

protected
  def collection
    @contacts ||= Contact.permitted_for(current_user).not_deleted.order('last_name', 'asc').
      paginate(:per_page => 10, :page => params[:page] || 1)
  end

  def resource
    @contact ||= Contact.permitted_for(current_user).find_by_id(params[:id])
  end

  def begin_of_association_chain
    current_user
  end
end
