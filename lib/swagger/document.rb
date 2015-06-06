require 'json'
require 'swagger/object'
require 'swagger/info'

module Swagger
  class Document < Swagger::Object  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swagger-object

    SPEC_VERSION = '2.0'  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields

    attr_swagger :swagger, :info

    def initialize
      @swagger = '2.0'
      @info = Swagger::Info.new
    end

    def self.parse(document)
      raise (ArgumentError.new("document object is nil [#{Swagger::Document._desc}]")) unless document
      raise (ArgumentError.new("the document is not a swagger #{SPEC_VERSION} version [#{Swagger::Document._desc}]")) unless document['swagger'] && "2.0" == document['swagger']

      d = Swagger::Document.new
      d.info = Swagger::Info.parse(document['info'])

      d
    end

    def swagger=(new_swagger)
      raise (ArgumentError.new("you can't change the swagger factor [#{Swagger::Document.swagger_desc}]"))
    end

    def info=(new_info)
      raise (ArgumentError.new("info object is nil [#{Swagger::Document.info_desc}]")) unless new_info
      @info = new_info
    end

    def valid?
      @info.valid?
    end

    def self._desc
      'Swagger::Document - This is the root document object for the API specification. It combines what previously was the Resource Listing and API Declaration (version 1.2 and earlier) together into one document. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swagger-object'
    end

    def self.swagger_desc
      'Swagger::Licence#swagger - Required. Specifies the Swagger Specification version being used. It can be used by the Swagger UI and other clients to interpret the API listing. The value MUST be "2.0".. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-3'
    end

    def self.info_desc
      'Swagger::Licence#info - Required. Provides metadata about the API. The metadata can be used by the clients if needed. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-3'
    end
  end
end