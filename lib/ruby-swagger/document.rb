require 'json'
require 'ruby-swagger/object'
require 'ruby-swagger/info'
require 'ruby-swagger/data/mime'
require 'ruby-swagger/data/paths'

module Swagger
  class Document < Swagger::Object  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swagger-object

    SPEC_VERSION = '2.0'  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields
    DEFAULT_HOST = 'localhost:80'

    attr_swagger :swagger, :info, :host, :basePath, :schemes, :consumes, :produces, :paths

    # create an empty document
    def initialize
      @swagger = '2.0'
      @info = Swagger::Info.new
      @paths = Swagger::Data::Paths.new
    end

    # parse an hash document into a set of Swagger objects
    #   document is a hash
    def self.parse(document)
      raise (ArgumentError.new("document object is nil [#{Swagger::Document._desc}]")) unless document
      raise (ArgumentError.new("the document is not a swagger #{SPEC_VERSION} version [#{Swagger::Document._desc}]")) unless document['swagger'] && "2.0" == document['swagger']

      d = Swagger::Document.new
      d.info = Swagger::Info.parse(document['info'])
      d.host = document['host']
      d.basePath = document['basePath']
      d.schemes = document['schemes']
      d.consumes = document['consumes']
      d.produces = document['produces']
      d.paths = Swagger::Data::Paths.parse(document['paths'])

      d
    end

    def swagger=(new_swagger)
      raise (ArgumentError.new("you can't change the swagger factor [#{Swagger::Document.swagger_desc}]"))
    end

    def info=(new_info)
      raise (ArgumentError.new("info object is nil [#{Swagger::Document.info_desc}]")) unless new_info
      @info = new_info
    end

    def host=(new_host)
      raise (ArgumentError.new("host is not a string [#{Swagger::Document.host_desc}]")) unless new_host
      @host = new_host
    end

    def basePath=(new_path)
      new_path = new_path.nil? ? '/' : new_path

      if !(new_path =~ /^\/.+$/)
        new_path = "/#{new_path}" #new path must start with a /
      end

      raise (ArgumentError.new("basePath is not a string [#{Swagger::Document.basePath_desc}]")) unless new_path

      @basePath ||= new_path
    end

    def schemes=(new_schemes)
      raise (ArgumentError.new("schemes is nil [#{Swagger::Document.schemes_desc}]")) unless new_schemes

      new_schemes.each do |scheme|
        raise (ArgumentError.new("unrecognized scheme #{scheme} [#{Swagger::Document.schemes_desc}]")) unless %w(http https ws wss).include?(scheme)
      end

      @schemes = new_schemes
    end

    def produces=(new_produces)
      raise (ArgumentError.new("produces is nil [#{Swagger::Document.produces_desc}]")) unless new_produces

      new_produces.each do |produce|
        raise (ArgumentError.new("unrecognized produce type #{produce} [#{Swagger::Document.produces_desc}]")) unless Swagger::Data::Mime.valid?(produce)
      end

      @produces = new_produces
    end

    def consumes=(new_consumes)
      raise (ArgumentError.new("produces is nil [#{Swagger::Document.consumes_desc}]")) unless new_consumes

      new_consumes.each do |consume|
        raise (ArgumentError.new("unrecognized consume type #{consume} [#{Swagger::Document.consumes_desc}]")) unless Swagger::Data::Mime.valid?(consume)
      end

      @consumes= new_consumes
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

    def self.basePath_desc
      'Swagger::Licence#basePath - The base path on which the API is served, which is relative to the host. If it is not included, the API is served directly under the host. The value MUST start with a leading slash (/). The basePath does not support path templating.'
    end

    def self.schemes_desc
      'Swagger::Licence#schemes - The transfer protocol of the API. Values MUST be from the list: "http", "https", "ws", "wss". If the schemes is not included, the default scheme to be used is the one used to access the specification.'
    end

    def self.consumes_desc
      'Swagger::Licence#consumes - A list of MIME types the APIs can consume. This is global to all APIs but can be overridden on specific API calls. Value MUST be as described under Mime Types.'
    end

    def self.produces_desc
      'Swagger::Licence#produces - A list of MIME types the APIs can produce. This is global to all APIs but can be overridden on specific API calls. Value MUST be as described under Mime Types.'
    end

    def self.paths_desc
      'Swagger::Licence#paths - Holds the relative paths to the individual endpoints. The path is appended to the basePath in order to construct the full URL. The Paths may be empty, due to ACL constraints.'
    end

  end
end