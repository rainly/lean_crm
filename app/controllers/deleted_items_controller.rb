class DeletedItemsController < ApplicationController

  before_filter :resource, :only => [:update, :destroy]

  def index
    @items ||= [
      Lead.permitted_for(current_user).all(:deleted_at => { '$ne' => nil }) +
      Contact.permitted_for(current_user).all(:deleted_at => { '$ne' => nil }) +
      Account.permitted_for(current_user).all(:deleted_at => { '$ne' => nil })
    ].flatten.sort_by(&:deleted_at)
  end

  def update
    @item.update_attributes :deleted_at => nil
    redirect_to deleted_items_path
  end

  def destroy
    @item.destroy_without_paranoid
    redirect_to deleted_items_path
  end

protected
  def resource
    @item ||= Lead.find(params[:id]) || Contact.find(params[:id]) || Account.find(params[:id])
  end
end
