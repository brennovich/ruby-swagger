require 'ruby-swagger/data/path'
require 'ruby-swagger/data/operation'

module Swagger::Grape
  class RoutePath

    def initialize(route_name)
      @name = route_name
      @operations = {}
    end

    def add_operation(route)
      @operations[route.route_method.downcase] = Swagger::Data::Operation.from_grape(@name, route)
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