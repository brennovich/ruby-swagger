require 'ruby-swagger/data/paths'

module Swagger::Grape
  class Routes

    def initialize(routes)
      @routes = routes
    end

    def to_swagger
      swagger = Swagger::Data::Paths.new

      @routes.each do |route|
        puts route.route_path
      end

      swagger
    end

  end
end