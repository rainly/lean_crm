# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def add_new(text,path)
    "<a href='#{path}' id='new'><b>+</b>#{text}</a>"
  end

  
end
