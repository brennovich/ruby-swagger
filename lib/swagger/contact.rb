require 'json'
require 'yaml'
require 'swagger/data/url'

module Swagger
  class Contact

    DEFAULT_NAME = 'John Doe'
    DEFAULT_EMAIL = 'john.doe@example.com'
    DEFAULT_URL = 'https://google.com/?q=john%20doe'

    attr_accessor :name, :email

    def initialize
      @name = DEFAULT_NAME
      @email = DEFAULT_EMAIL
      @url = Swagger::Data::Url.new DEFAULT_URL
    end

    def self.parse(contact)
      raise (ArgumentError.new("contact object is nil [#{Swagger::Contact._desc}]")) unless contact

      Swagger::Contact.new._init(contact['name'], contact['url'], contact['email'])
    end

    def to_json
      to_swagger.to_json
    end

    def to_yaml
      to_swagger.to_yaml
    end

    def to_swagger
      {
          name: @name,
          url: @url.to_swagger,
          email: @email
      }
    end

    def url=(url)
      @url = Swagger::Data::Url.new(url)
      validate_url!
    end

    def url
      @url.url
    end

    def _init(name, url, email)
      @name = name
      @url = Swagger::Data::Url.new(url)
      @email = email

      validate_url!

      self
    end

    def self._desc
      'Swagger::Contact - Contact information for the exposed API. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#contact-object'
    end

    def self.name_desc
      'Swagger::Contact#name - The identifying name of the contact person/organization. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-3'
    end

    def self.url_desc
      'Swagger::Contact#name - The URL pointing to the contact information. MUST be in the format of a URL. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-3'
    end

    def self.email_desc
      'Swagger::Contact#name - The email address of the contact person/organization. MUST be in the format of an email address. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-3'
    end

    private

    def validate_url!
      raise (ArgumentError.new("contact url is invalid [#{Swagger::Contact.url_desc}]")) unless @url.valid?
    end

  end
end