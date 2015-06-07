require 'swagger/object'
require 'swagger/contact'
require 'swagger/license'

module Swagger
  class Info < Swagger::Object  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#info-object

    DEFAULT_TITLE = 'My uber-duper API'
    DEFAULT_DESCRIPTION = 'My uber-duper API description'
    DEFAULT_VERSION = '0.1'

    attr_swagger :title, :description, :termsOfService, :contact, :license, :version

    def initialize
      @title = DEFAULT_TITLE
      @description = DEFAULT_DESCRIPTION
      @version = DEFAULT_VERSION
    end

    def self.parse(info)
      raise (ArgumentError.new("info object is nil [#{Swagger::Info._desc}]")) unless info

      i = Swagger::Info.new

      i.title = info['title']
      i.description = info['description']
      i.termsOfService = info['termsOfService']
      i.contact = Swagger::Contact.parse(info['contact'])
      i.license = Swagger::License.parse(info['license'])
      i.version = info['version']

      i
    end

    def title=(new_title)
      raise (ArgumentError.new("title is invalid [#{Swagger::Info.title_desc}]")) if new_title.nil? || new_title.empty?
      @title = new_title
    end

    def description=(new_description)
      raise (ArgumentError.new("description is invalid [#{Swagger::Info.description_desc}]")) if new_description.nil? || new_description.empty?
      @description = new_description
    end

    def contact=(new_contact)
      raise (ArgumentError.new("contact is invalid [#{Swagger::Info.contact_desc}]")) if new_contact.nil? || !new_contact.is_a?(Swagger::Contact)
      @contact = new_contact
    end

    def license=(new_license)
      raise (ArgumentError.new("license is invalid [#{Swagger::Info.license_desc}]")) if new_license.nil? || !new_license.is_a?(Swagger::License)
      @license = new_license
    end

    def version=(new_version)
      raise (ArgumentError.new("version is invalid [#{Swagger::Info.version_desc}]")) if new_version.nil? || new_version.empty?
      @version = new_version
    end

    def valid?
      @license.valid? && @contact.valid?
    end

    def self._desc
      'Swagger::Info - The object provides metadata about the API. The metadata can be used by the clients if needed, and can be presented in the Swagger-UI for convenience. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-1'
    end

    def self.title_desc
      'Swagger::Info#title_desc - Required. The title of the application. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-1'
    end

    def self.description_desc
      'Swagger::Info#description_desc - Required. A short description of the application. GFM syntax can be used for rich text representation. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-1'
    end

    def self.termsOfService_desc
      'Swagger::Info#termsOfService - The Terms of Service for the API. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-1'
    end

    def self.contact_desc
      'Swagger::Info#contact - The contact information for the exposed API. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-1'
    end

    def self.license_desc
      'Swagger::Info#license - The license information for the exposed API. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-1'
    end

    def self.version_desc
      'Swagger::Info#version - Required Provides the version of the application API (not to be confused with the specification version). See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-1'
    end

  end
end