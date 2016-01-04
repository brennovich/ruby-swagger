require 'ruby-swagger/object'
require 'ruby-swagger/data/reference'
require 'ruby-swagger/data/xml_object'
require 'ruby-swagger/data/external_documentation'

module Swagger::Data
  class Schema < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#schemaObject
    attr_swagger :discriminator, :readOnly, :xml, :externalDocs, :example,
                 :format, :title, :description, :default,
                 :multipleOf, :maximum, :exclusiveMaximum, :minimum,
                 :exclusiveMinimum, :maxLength, :minLength,
                 :pattern, :maxItems, :minItems, :uniqueItems, :maxProperties,
                 :minProperties, :required, :enum, :type, :items, :allOf,
                 :properties, :additionalProperties

    attr_reader :ref

    def self.parse(schema)
      return nil if schema.nil?

      sc = Swagger::Data::Schema.new.bulk_set(schema)
      sc.ref = schema['$ref']
      sc
    end

    def ref=(new_ref)
      return nil unless new_ref

      @ref = new_ref
    end

    def externalDocs=(new_doc)
      return nil unless new_doc

      unless new_doc.is_a?(Swagger::Data::ExternalDocumentation)
        new_doc = Swagger::Data::ExternalDocumentation.parse(new_doc)
      end

      @externalDocs = new_doc
    end

    def xml=(new_xml)
      return nil unless new_xml

      unless new_xml.is_a?(Swagger::Data::XMLObject)
        new_xml = Swagger::Data::XMLObject.parse(new_xml)
      end

      @xml = new_xml
    end

    def []=(attrib, value)
      send("#{attrib}=", value)
    end

    def [](attrib)
      send("#{attrib}")
    end

    def as_swagger
      res = super
      res['$ref'] = @ref if @ref
      res
    end
  end
end
