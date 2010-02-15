class TasksController < InheritedResources::Base

  def create
    create! do |success, failure|
      success.html { return_to_or_default task_path(@task) }
    end
  end

  def update
    update! do |success, failure|
      success.html do
        unless params[:task][:assignee_id].blank?
          flash[:notice] = I18n.t('task_reassigned', :user => @task.assignee.email)
        end
        return_to_or_default tasks_path
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { return_to_or_default tasks_path }
    end
  end

protected
  def build_resource
    @task ||= begin_of_association_chain.tasks.build params[:task]
    @task.asset_id = params[:asset_id] if params[:asset_id]
    @task.asset_type = params[:asset_type] if params[:asset_type]
    @task
  end

  def collection
    @tasks ||= current_user.tasks.all
  end

  def begin_of_association_chain
    current_user
  end
end
