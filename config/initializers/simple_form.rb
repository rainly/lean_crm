SimpleForm.wrapper_tag = :div

module SimpleForm
  module Components
    module Wrapper
      def wrapper_html_options
        html_options_for(:wrapper, input_type, required_class, options[:grid])
      end
    end
  end
end        
module SimpleForm
  module Inputs
    class Base

    protected
      def attribute_required?
        options[:required] || false
      end
    end
  end
end