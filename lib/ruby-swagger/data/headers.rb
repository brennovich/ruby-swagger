require 'ruby-swagger/object'
require 'ruby-swagger/data/header'

module Swagger::Data
  class Headers < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#headersObject
    def initialize
      @headers = {}
    end

    def self.parse(headers)
      return nil unless headers

      h = Swagger::Data::Headers.new

      headers.each { |header_key, header_value| h.add_header(header_key, header_value) }

      h
    end

    def add_header(header_key, header_value)
      raise ArgumentError.new('Swagger::Data::Headers#add_header - parameter name is nil') unless header_key
      raise ArgumentError.new('Swagger::Data::Headers#add_header - parameter value is nil') unless header_value

      unless header_value.is_a?(Swagger::Data::Header)
        header_value = Swagger::Data::Header.parse(header_value)
      end

      @headers[header_key] = header_value
    end

    def [](key)
      @headers[key]
    end

    def as_swagger
      res = {}

      @headers.each do |key, value|
        res[key] = value.to_swagger
      end

      res
    end
  end
end
