class ContactsController < InheritedResources::Base

protected
  def collection
    @contacts ||= current_user.contacts
  end

  def begin_of_association_chain
    current_user
  end
end
