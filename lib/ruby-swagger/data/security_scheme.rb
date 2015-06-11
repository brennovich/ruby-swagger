require 'ruby-swagger/object'

module Swagger::Data
  class SecurityScheme < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#securitySchemeObject

    attr_swagger :type, :description, :name, :in, :flow, :authorizationUrl, :tokenUrl, :scopes

    def self.parse(security)
      return nil unless security

      Swagger::Data::SecurityScheme.new.bulk_set(security)
    end

    def type=(new_type)
      raise ArgumentError.new("Security::Data::SecurityScheme#type= - type is nil") unless new_type
      raise ArgumentError.new("Security::Data::SecurityScheme#type= - unrecognized type #{new_type}") unless %w(basic apiKey oauth2).include?(new_type)

      @type = new_type
    end

    def name=(new_name)
      raise ArgumentError.new("Security::Data::SecurityScheme#name= - name is nil") unless new_name

      @name = new_name
    end

    def in=(new_in)
      raise ArgumentError.new("Security::Data::SecurityScheme#in= - in is nil") unless new_in
      raise ArgumentError.new("Security::Data::SecurityScheme#in= - unrecognized in #{new_in}") unless %w(query header).include?(new_in)

      @in = new_in
    end

    def flow=(new_flow)
      raise ArgumentError.new("Security::Data::SecurityScheme#flow= - flow is nil") unless new_flow

      @flow = new_flow
    end

    def authorizationUrl=(new_authorizationUrl)
      raise ArgumentError.new("Security::Data::SecurityScheme#authorizationUrl= - authorizationUrl is nil") unless new_authorizationUrl

      @authorizationUrl = new_authorizationUrl
    end

    def tokenUrl=(new_tokenUrl)
      raise ArgumentError.new("Security::Data::SecurityScheme#tokenUrl= - tokenUrl is nil") unless new_tokenUrl

      @tokenUrl = new_tokenUrl
    end

    def scopes=(new_scopes)
      raise ArgumentError.new("Security::Data::SecurityScheme#scopes= - scopes is nil") unless new_scopes

      new_scopes = Swagger::Data::Scopes.parse(new_scopes) if(!new_scopes.is_a?(Swagger::Data::Scopes))

      @scopes = new_scopes
    end

  end
end