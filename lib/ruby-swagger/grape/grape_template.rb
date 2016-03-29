require 'ruby-swagger/data/document'
require 'ruby-swagger/template'
require 'ruby-swagger/data/definitions'
require 'ruby-swagger/grape/routes'
require 'ruby-swagger/grape/type'
require 'ruby-swagger/data/security_scheme'
require 'ruby-swagger/data/security_definitions'

module Swagger::Grape
  class Template
    def self.generate(base_class)
      swagger_doc = Swagger::Template.generate

      routes = Swagger::Grape::Routes.new(base_class.routes)


      swagger_doc.paths = routes.to_swagger
      swagger_doc.definitions = Swagger::Data::Definitions.new

      extract_all_types(routes.types).sort { |a, b| a.to_s <=> b.to_s }.each do |type|
        grape_type = Swagger::Grape::Type.new(type)

        # Skip runtime defintions
        next if type.to_s.include?('Class')

        swagger_doc.definitions.add_definition(type.to_s, grape_type.to_swagger(false))
      end

      if routes.scopes.present?
        scheme = Swagger::Data::SecurityScheme.new
        scheme.type = 'oauth2'
        scheme.flow = 'accessCode'
        scheme.authorizationUrl = 'https://'
        scheme.tokenUrl = 'https://'
        scopes = {}
        routes.scopes.uniq.each do |scope|
          scopes[scope] = ''
        end
        scheme.scopes = scopes

        swagger_doc.securityDefinitions = Swagger::Data::SecurityDefinitions.new
        swagger_doc.securityDefinitions.add_param('oauth2', scheme)
      end

      swagger_doc
    end

    def self.extract_all_types(types, all_types = [])
      return all_types.uniq if types.length == 0

      new_types = []

      types.each do |type|
        all_types << type unless all_types.map(&:to_s).include?(type.to_s)

        grape_type = Swagger::Grape::Type.new(type)

        grape_type.sub_types.each do |new_type|
          unless all_types.map(&:to_s).include?(new_type.to_s)
            new_types << new_type
            all_types << new_type
          end
        end
      end

      extract_all_types(new_types, all_types)
    end
  end
end
