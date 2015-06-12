require 'ruby-swagger/object'

module Swagger::Data
  class Headers < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#headersObject

    @headers = {}

    def self.parse(headers)
      return nil unless headers

      h = Swagger::Operations::Headers.new

      headers.each {|header_key, header_value| h.add_header(header_key, header_value) }

      h
    end

    def add_header(header_key, header_value)
      @responses[header_key] = header_value
    end

    def as_swagger
      res = super

      @headers.each do |key, value|
        res[key] = value.to_swagger
      end

      res
    end


  end
end