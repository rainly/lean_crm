SimpleForm.wrapper_tag = :div
       
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