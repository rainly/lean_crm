class CommentsController < InheritedResources::Base

  respond_to :html
  respond_to :xml

  def create
    create! do |success, failure|
      success.html { redirect_to params[:return_to] || comments_path }
    end
  end
  
  def update
    update! do |success, failure|
      success.html do
        flash[:notice] = I18n.t('comment_updated')
        return_to_or_default url_for(
          :controller => @comment.commentable_type.downcase.pluralize,
          :action     => 'show',
          :id         => @comment.commentable_id
        )
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { return_to_or_default tasks_path }
    end
  end

protected
  def begin_of_association_chain
    current_user
  end
end
