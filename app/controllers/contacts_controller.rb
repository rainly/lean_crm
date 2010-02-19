class ContactsController < InheritedResources::Base

protected
  def collection
    @contacts ||= current_user.contacts.not_deleted
  end

  def begin_of_association_chain
    current_user
  end
end
