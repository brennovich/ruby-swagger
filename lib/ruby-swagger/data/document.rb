require 'json'
require 'ruby-swagger/object'
require 'ruby-swagger/data/info'
require 'ruby-swagger/data/mime'
require 'ruby-swagger/data/paths'
require 'ruby-swagger/data/definitions'
require 'ruby-swagger/data/parameters'
require 'ruby-swagger/data/responses'
require 'ruby-swagger/data/security_definitions'
require 'ruby-swagger/data/security_requirement'
require 'ruby-swagger/data/tag'
require 'ruby-swagger/data/external_documentation'

module Swagger::Data
  class Document < Swagger::Object  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swagger-object

    SPEC_VERSION = '2.0'  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields
    DEFAULT_HOST = 'localhost:80'

    attr_swagger :swagger, :info, :host, :basePath, :schemes, :consumes,
                 :produces, :paths, :definitions, :parameters, :responses, :securityDefinitions,
                 :security, :tags, :externalDocs

    # create an empty document
    def initialize
      @swagger = '2.0'
      @info = Swagger::Data::Info.new
      @paths = Swagger::Data::Paths.new
    end

    # parse an hash document into a set of Swagger objects
    #   document is a hash
    def self.parse(document)
      raise (ArgumentError.new("Swagger::Document#parse - document object is nil")) unless document

      Swagger::Data::Document.new.bulk_set(document)
    end

    def swagger=(new_swagger)
      raise (ArgumentError.new("Swagger::Document#swagger= - the document is not a swagger #{SPEC_VERSION} version")) unless "2.0" == new_swagger
      @swagger = new_swagger
    end

    def info=(new_info)
      raise (ArgumentError.new("Swagger::Document#info= - info object is nil")) unless new_info

      new_info = Swagger::Data::Info.parse(new_info) unless new_info.is_a?(Swagger::Data::Info)

      @info = new_info
    end

    def basePath=(new_path)
      new_path = new_path.nil? ? '/' : new_path

      if !(new_path =~ /^\/.+$/)
        new_path = "/#{new_path}" #new path must start with a /
      end

      @basePath ||= new_path
    end

    def schemes=(new_schemes)
      return nil unless new_schemes

      new_schemes.each do |scheme|
        raise (ArgumentError.new("Swagger::Data::Document#schemes= - unrecognized scheme #{scheme}")) unless %w(http https ws wss).include?(scheme)
      end

      @schemes = new_schemes
    end

    def produces=(new_produces)
      return nil unless new_produces

      new_produces.each do |produce|
        raise (ArgumentError.new("Swagger::Data::Document#produces= - unrecognized produce type #{produce}")) unless Swagger::Data::Mime.valid?(produce)
      end

      @produces = new_produces
    end

    def consumes=(new_consumes)
      return nil unless new_consumes

      new_consumes.each do |consume|
        raise (ArgumentError.new("Swagger::Data::Document#consumes= - unrecognized consume type #{consume}]")) unless Swagger::Data::Mime.valid?(consume)
      end

      @consumes= new_consumes
    end

    def paths=(new_paths)
      raise ArgumentError.new("Swagger::Data::Document#paths= - paths is nil") unless paths

      new_paths = Swagger::Data::Paths.parse(new_paths) if(!new_paths.is_a?(Swagger::Data::Paths))

      @paths = new_paths
    end

    def definitions=(new_definitions)
      return nil unless new_definitions

      if (!new_definitions.is_a?(Swagger::Data::Definitions))
        new_definitions = Swagger::Data::Definitions.parse(new_definitions)
      end

      @definitions = new_definitions
    end

    def parameters=(new_parameters)
      return nil unless new_parameters

      if (!new_parameters.is_a?(Swagger::Data::Parameters))
        new_parameters = Swagger::Data::Parameters.parse(new_parameters)
      end

      @parameters = new_parameters
    end

    def responses=(new_responses)
      return nil unless new_responses

      if (!new_responses.is_a?(Swagger::Data::Responses))
        new_responses = Swagger::Data::Responses.parse(new_responses)
      end

      @responses = new_responses
    end

    def securityDefinitions=(newSecurityDef)
      return nil unless newSecurityDef

      if (!newSecurityDef.is_a?(Swagger::Data::SecurityDefinitions))
        newSecurityDef = Swagger::Data::SecurityDefinitions.parse(newSecurityDef)
      end

      @securityDefinitions= newSecurityDef
    end

    def security=(new_security)
      return nil unless new_security

      if (!new_security.is_a?(Swagger::Data::SecurityRequirement))
        new_security = Swagger::Data::SecurityRequirement.parse(new_security)
      end

      @security = new_security
    end

    def tags=(new_tags)
      return nil unless new_tags

      @tags = []

      new_tags.each do |tag|
        add_tag(tag)
      end
    end

    def add_tag(new_tag)
      return nil unless new_tag

      if (!new_tag.is_a?(Swagger::Data::Tag))
        new_tag = Swagger::Data::Tag.parse(new_tag)
      end

      @tags.push(new_tag)
    end

    def externalDocs=(new_externalDocs)
      return nil unless new_externalDocs

      if (!new_externalDocs.is_a?(Swagger::Data::ExternalDocumentation))
        new_externalDocs = Swagger::Data::ExternalDocumentation.parse(new_externalDocs)
      end

      @externalDocs = new_externalDocs
    end

  end
end