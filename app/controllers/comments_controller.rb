class CommentsController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { redirect_to params[:return_to] || comments_path }
    end
  end

protected
  def begin_of_association_chain
    current_user
  end
end
