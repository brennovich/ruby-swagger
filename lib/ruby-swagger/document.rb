require 'json'
require 'ruby-swagger/object'
require 'ruby-swagger/info'

module Swagger
  class Document < Swagger::Object  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swagger-object

    SPEC_VERSION = '2.0'  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields
    DEFAULT_HOST = 'localhost:80'

    attr_swagger :swagger, :info, :host, :basePath #, :schemes, :consumes, :produces

    def initialize
      @swagger = '2.0'
      @info = Swagger::Info.new
    end

    def self.parse(document)
      raise (ArgumentError.new("document object is nil [#{Swagger::Document._desc}]")) unless document
      raise (ArgumentError.new("the document is not a swagger #{SPEC_VERSION} version [#{Swagger::Document._desc}]")) unless document['swagger'] && "2.0" == document['swagger']

      d = Swagger::Document.new
      d.info = Swagger::Info.parse(document['info'])
      d.host = document['host']
      d.basePath = document['basePath']

      d
    end

    def swagger=(new_swagger)
      raise (ArgumentError.new("you can't change the swagger factor [#{Swagger::Document.swagger_desc}]"))
    end

    def info=(new_info)
      raise (ArgumentError.new("info object is nil [#{Swagger::Document.info_desc}]")) unless new_info
      @info = new_info
    end

    def basePath=(new_path)
      new_path = new_path.nil? ? '/' : new_path

      if !(new_path =~ /^\/.+$/)
        new_path = "/#{new_path}" #new path must start with a /
      end

      @basePath ||= new_path
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

    def self.host_desc
      'Swagger::Licence#host - The host (name or ip) serving the API. This MUST be the host only and does not include the scheme nor sub-paths. It MAY include a port. If the host is not included, the host serving the documentation is to be used (including the port). The host does not support path templating.'
    end

    def self.basePath
      'Swagger::Licence#basePath - The base path on which the API is served, which is relative to the host. If it is not included, the API is served directly under the host. The value MUST start with a leading slash (/). The basePath does not support path templating.'
    end
  end
end