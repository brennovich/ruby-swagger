require 'ruby-swagger/object'

module Swagger::Data
  class Scopes < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#scopesObject
    def initialize
      @scopes = {}
    end

    def self.parse(scopes)
      return nil unless scopes

      scope = Swagger::Data::Scopes.new

      scopes.each do |scope_name, scope_value|
        scope.add_scope(scope_name, scope_value)
      end

      scope
    end

    def add_scope(scope_name, scope_value)
      raise ArgumentError.new('Swagger::Data::Scopes#add_scope - scope_name is nil') unless scope_name
      raise ArgumentError.new('Swagger::Data::Scopes#add_scope - scope_value is nil') unless scope_value

      @scopes[scope_name] = scope_value
    end

    def [](scope)
      @scopes[scope]
    end

    def as_swagger
      swagger_scopes = {}

      @scopes.each do |scope_k, scope_v|
        swagger_scopes[scope_k] = scope_v
      end

      swagger_scopes
    end
  end
end
