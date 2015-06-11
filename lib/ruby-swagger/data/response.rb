require 'ruby-swagger/object'
require 'ruby-swagger/data/schema'
require 'ruby-swagger/data/headers'
require 'ruby-swagger/data/example'

module Swagger::Data
  class Response < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#responseObject

    attr_swagger :description, :schema, :headers, :examples

    def self.parse(response)
      return nil unless response

      r = Swagger::Data::Response.new

      r.description = response['description']
      r.schema = Swagger::Data::Schema.parse(response['schema'])
      r.headers = Swagger::Data::Headers.parse(response['headers'])
      r.examples = Swagger::Data::Example.parse(response['examples'])

      r
    end

  end
end