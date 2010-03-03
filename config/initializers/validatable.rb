module Validatable
  class Errors
    def to_xml
      require 'builder'
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.errors do
        errors.each do |key, values|
          values.each do |value|
            xml.error "#{key} #{value}"
          end
        end
      end
    end
  end
end
