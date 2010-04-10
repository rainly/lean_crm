class TasksController < InheritedResources::Base

  has_scope :assigned,              :type => :boolean
  has_scope :completed,             :type => :boolean
  has_scope :incomplete,            :type => :boolean
  has_scope :overdue,               :type => :boolean
  has_scope :due_today,             :type => :boolean
  has_scope :due_tomorrow,          :type => :boolean
  has_scope :due_this_week,         :type => :boolean
  has_scope :due_next_week,         :type => :boolean
  has_scope :due_later,             :type => :boolean
  has_scope :completed_today,       :type => :boolean
  has_scope :completed_yesterday,   :type => :boolean
  has_scope :completed_last_week,   :type => :boolean
  has_scope :completed_this_month,  :type => :boolean
  has_scope :completed_last_month,  :type => :boolean

  def create
    create! do |success, failure|
      success.html { return_to_or_default asset_path }
    end
  end

  def update
    update! do |success, failure|
      success.html do
        return_to_or_default asset_path
        unless params[:task][:assignee_id].blank?
          flash[:notice] = I18n.t('task_reassigned', :user => @task.assignee.email)
        end
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html { return_to_or_default asset_path }
    end
  end

protected
  
  def asset_path
    url_for(
      :controller => @task.asset.class.to_s.downcase.pluralize,
      :action     => 'show',
      :id         => @task.asset.id
    )
  end
  
  def build_resource
    @task ||= begin_of_association_chain.tasks.build({ :assignee_id => current_user.id }.
                                                     merge(params[:task] || {}))
    @task.asset_id = params[:asset_id] if params[:asset_id]
    @task.asset_type = params[:asset_type] if params[:asset_type]
    @task
  end

  def collection
    if params[:scopes]
      @tasks ||= Task.grouped_by_scope(params[:scopes].map {|k,v| k.to_sym },
                                       :target => apply_scopes(Task).for(current_user))
    else
      @tasks ||= apply_scopes(Task).for(current_user)
    end
  end

  def resource
    @task ||= Task.for(current_user).find_by_id(params[:id])
  end

  def begin_of_association_chain
    current_user
  end
end
