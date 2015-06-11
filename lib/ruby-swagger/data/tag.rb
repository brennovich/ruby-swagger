require 'ruby-swagger/object'
require 'ruby-swagger/data/external_documentation'

module Swagger::Data
  class Tag < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#tag-object

    attr_swagger :name, :description, :externalDocs

    def self.parse(xml_object)
      return nil unless xml_object

      Swagger::Data::Tag.new.bulk_set(xml_object)
    end

    def externalDocs=(newDoc)
      return nil unless newDoc

      newDoc = Swagger::Data::ExternalDocumentation.parse(newDoc) unless newDoc.is_a?(Swagger::Data::ExternalDocumentation)

      @externalDocs=newDoc
    end

  end
end