require 'ruby-swagger/object'

module Swagger::Data
  class ExternalDocumentation < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#externalDocumentationObject

    attr_swagger :url, :description

    def initialize
      @url = "http://localhost"
    end

    def self.parse(external)
      return nil unless external

      Swagger::Data::ExternalDocumentation.new.bulk_set(external)
    end

    def url=(new_url)
      raise (ArgumentError.new("Swagger::Data::ExternalDocumentation#url - url is nil")) unless new_url
      @url = url
    end

  end
end