require 'ruby-swagger/object'
require 'ruby-swagger/data/reference'
require 'ruby-swagger/data/response'

module Swagger::Data
  class Responses < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#responsesObject

    @responses = {}

    def self.parse(responses)
      return nil unless responses

      r = Swagger::Operations::Responses.new

      responses.each do |response_key, response_value|
        response = if response_value['$ref']
                       #it's a reference object
                       Swagger::Data::Reference.parse(response_value)
                     else
                       #it's a parameter object
                       Swagger::Data::Response.parse(response_value)
                     end

        r.add_response(response_key, response)
      end

      r
    end

    def add_response(response_code, response)
      @responses[response_code] = response
    end

    def as_swagger
      res = super

      @responses.each do |other_name, other_value|
        res[other_name] = other_value.to_swagger
      end

      res
    end

  end
end