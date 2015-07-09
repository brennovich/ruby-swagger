require 'ruby-swagger/data/paths'
require 'ruby-swagger/data/path'
require 'ruby-swagger/grape/route_path'

module Swagger::Grape
  class Routes

    attr_reader :types, :scopes

    def initialize(routes)
      @routes = routes
      @types = []
      @scopes = []
    end

    def to_swagger
      swagger = Swagger::Data::Paths.new
      paths = {}

      @routes.each do |route|

        next if route.route_hidden == true  #implement custom "hidden" extension

        swagger_path_name = swagger_path_name(route)
        paths[swagger_path_name] ||= Swagger::Grape::RoutePath.new(swagger_path_name)
        paths[swagger_path_name].add_operation(route)
      end

      paths.each do |path_name, path|
        swagger.add_path(path_name, path.to_swagger)
        @types = (@types | path.types).uniq
        @scopes = (@scopes | path.scopes).uniq
      end

      swagger
    end

    private

    def swagger_path_name(grape_route)
      grape_path_name = grape_route.route_path
      grape_prefix = grape_route.route_prefix
      grape_path_name.gsub!(/^\/#{grape_prefix}/, '') if grape_prefix
      grape_path_name.gsub!(/^\/:version/, '') #remove api version - if any
      grape_path_name.gsub!(/\(\.:format\)$/, '') #remove api format - if any
      grape_path_name.gsub!(/\(\..+\)$/, '') #remove api format - if any
      grape_path_name.gsub!(/\/:([a-zA-Z0-9_]+)/, '/{\1}')  #convert parameters from :format into {format}
      grape_path_name
    end

  end
end