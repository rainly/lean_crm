class DeletedItemsController < ApplicationController

  before_filter :resource, :only => [:update, :destroy]

  def index
    @items ||= [
      Lead.all(:deleted_at => { '$ne' => nil }) +
      Contact.all(:deleted_at => { '$ne' => nil }) +
      Account.all(:deleted_at => { '$ne' => nil })
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
