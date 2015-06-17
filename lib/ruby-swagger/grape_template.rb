require 'ruby-swagger/data/document'
require 'ruby-swagger/template'
require 'ruby-swagger/grape/routes'

module Swagger
  class GrapeTemplate

    def self.generate(base_class)
      swagger_doc = Swagger::Template.generate

      swagger_doc.paths = Swagger::Grape::Routes.new(base_class.routes).to_swagger

      swagger_doc
    end

  end
end