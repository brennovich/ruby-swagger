require 'json'
require 'yaml'
require 'ruby-swagger/data/url'
require 'ruby-swagger/object'

module Swagger
  class Contact < Swagger::Object

    DEFAULT_NAME = 'John Doe'
    DEFAULT_EMAIL = 'john.doe@example.com'
    DEFAULT_URL = 'https://google.com/?q=john%20doe'

    attr_swagger :name, :email, :url

    def initialize
      @name = DEFAULT_NAME
      @email = DEFAULT_EMAIL
      @url = Swagger::Data::Url.new DEFAULT_URL
    end

    def self.parse(contact)
      raise (ArgumentError.new("contact object is nil [#{Swagger::Contact._desc}]")) unless contact

      c = Swagger::Contact.new

      c.name, c.url, c.email = contact['name'], contact['url'], contact['email']
      c.validate_url!

      c
    end

    def url=(url)
      @url = Swagger::Data::Url.new(url)
      validate_url!
    end

    def url
      @url.url
    end

    def valid?
      true
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

    def validate_url!
      raise (ArgumentError.new("contact url is invalid [#{Swagger::Contact.url_desc}]")) unless @url.valid?
    end

  end
end