require 'ruby-swagger/data/paths'
require 'ruby-swagger/data/path'
require 'ruby-swagger/grape/route_path'

module Swagger::Grape
  class Routes

    def initialize(routes)
      @routes = routes
    end

    def to_swagger
      swagger = Swagger::Data::Paths.new
      paths = {}

      @routes.each do |route|

        swagger_path_name = swagger_path_name(route.route_path)
        paths[swagger_path_name] ||= Swagger::Grape::RoutePath.new(swagger_path_name)
        paths[swagger_path_name].add_operation(route)

      end

      paths.each do |path_name, path|
        swagger.add_path(path_name, path.to_swagger)
      end

      swagger
    end

    private

    def swagger_path_name(grape_path_name)
      grape_path_name.gsub!(/^\/:version/, '') #remove api version - if any
      grape_path_name.gsub!(/\(\.:format\)$/, '') #remove api format - if any
      grape_path_name.gsub!(/\/:([a-zA-Z0-9_]+)/, '/{\1}')  #convert parameters from :format into {format}
      grape_path_name
    end

  end
end