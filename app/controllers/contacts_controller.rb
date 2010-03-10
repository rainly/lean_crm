class ContactsController < InheritedResources::Base
  before_filter :merge_updater_id, :only => [:update]

  respond_to :html
  respond_to :xml

  def create
    create! do |success, failure|
      success.xml { head :ok }
    end
  end

  def destroy
    resource
    @contact.updater_id = current_user.id
    @contact.destroy
    redirect_to contacts_path
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

  def merge_updater_id
    params[:contact].merge!(:updater_id => current_user.id) if params[:contact]
  end
end
