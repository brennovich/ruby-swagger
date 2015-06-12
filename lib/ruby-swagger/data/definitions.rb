require 'ruby-swagger/object'
require 'ruby-swagger/data/schema'

module Swagger::Data
  class Definitions < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#definitionsObject

    def initialize
      @definitions = {}
    end

    def self.parse(definitions)
      return nil unless definitions

      definition = Swagger::Data::Definitions.new

      definitions.each do |definition_name, definition_value|
        definition.add_definition(definition_name, definition_value)
      end

      definition
    end

    def add_definition(definition_name, definition_value)
      raise ArgumentError.new("Swagger::Data::Definitions#add_definition - definition_name is nil") unless definition_name
      raise ArgumentError.new("Swagger::Data::Definitions#add_definition - definition_value is nil") unless definition_value

      if !definition_value.is_a?(Swagger::Data::Schema)
        definition_value = Swagger::Data::Schema.parse(definition_value)
      end

      @definitions[definition_name] = definition_value
    end

    def as_swagger
      swagger_defs = {}

      @definitions.each do |def_k, def_v|
        swagger_defs[def_k] = def_v
      end

      swagger_defs
    end

  end
end