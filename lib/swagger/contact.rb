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
      raise (ArgumentError.new('contact object is nil')) unless contact

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

    private

    def validate_url!
      raise (ArgumentError.new('contact url is invalid')) unless @url.valid?
    end

  end
end