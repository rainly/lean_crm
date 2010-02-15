class AccountsController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { return_to_or_default account_path(@account) }
    end
  end

protected
  def collection
    @accounts ||= current_user.accounts
  end

  def begin_of_association_chain
    current_user
  end
end
