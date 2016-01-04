require 'ruby-swagger/object'

module Swagger::Data
  class XMLObject < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#xmlObject
    attr_swagger :name, :namespace, :prefix, :attribute, :wrapped

    def self.parse(xml_object)
      return nil unless xml_object

      Swagger::Data::XMLObject.new.bulk_set(xml_object)
    end
  end
end
