require 'ruby-swagger/data/path'
require 'ruby-swagger/data/operation'
require 'ruby-swagger/grape/method'

module Swagger::Grape
  class RoutePath
    attr_reader :types, :scopes

    def initialize(route_name)
      @name = route_name
      @operations = {}
      @types = []
      @scopes = []
    end

    def add_operation(route)
      method = Swagger::Grape::Method.new(@name, route)
      grape_operation = method.operation

      @types = (@types | method.types).uniq
      @scopes = (@scopes | method.scopes).uniq
      @operations[route.route_method.downcase] = grape_operation
    end

    def to_swagger
      path = Swagger::Data::Path.new

      @operations.each do |operation_verb, operation|
        path.send("#{operation_verb}=", operation)
      end

      path
    end
  end
end
