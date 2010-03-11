module DomView
  def partial_path(*args, &block)
    ActionController::RecordIdentifier.partial_path(*args, &block)
  end
  def dom_class(*args, &block)
    ActionController::RecordIdentifier.dom_class(*args, &block)
  end
  def dom_id(*args, &block)
    ActionController::RecordIdentifier.dom_id(*args, &block)
  end
end

World DomView
