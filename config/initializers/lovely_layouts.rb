module LovelyLayouts

  module ContentHelpers


    protected

    def default_body_id
      if params[:controller]
        params[:controller].gsub('/','_')
      else
        'error'
      end
    end

    def default_body_class
      if params[:controller] && params[:controller]
        [params[:controller], params[:action]].join(" ").gsub('/','_')
      else
        'error'
      end
    end


  end

end

