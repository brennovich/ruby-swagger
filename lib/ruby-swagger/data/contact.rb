require 'json'
require 'yaml'
require 'ruby-swagger/data/url'
require 'ruby-swagger/object'

module Swagger::Data
  class Contact < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#contactObject
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
      return nil unless contact
      c = Swagger::Data::Contact.new.bulk_set(contact)
      c.validate_url!
      c
    end

    def url=(url)
      return nil unless url
      @url = Swagger::Data::Url.new(url)
    end

    def url
      @url.url
    end

    def valid?
      true
    end

    def validate_url!
      raise ArgumentError.new('Swagger::Data::Contact - contact url is invalid') if @url && !@url.valid?
    end
  end
end
