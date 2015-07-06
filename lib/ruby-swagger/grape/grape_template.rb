require 'ruby-swagger/data/document'
require 'ruby-swagger/template'
require 'ruby-swagger/data/definitions'
require 'ruby-swagger/grape/routes'
require 'ruby-swagger/grape/type'

module Swagger::Grape
  class Template

    def self.generate(base_class)
      swagger_doc = Swagger::Template.generate

      routes = Swagger::Grape::Routes.new(base_class.routes)

      swagger_doc.paths = routes.to_swagger
      swagger_doc.definitions = Swagger::Data::Definitions.new

      routes.types.sort.each do |type|
        grape_type = Swagger::Grape::Type.new(type)
        swagger_doc.definitions.add_definition(type.to_s, grape_type.to_swagger)
      end

      swagger_doc
    end

  end
end