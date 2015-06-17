require 'ruby-swagger/object'
require 'ruby-swagger/data/security_scheme'

module Swagger::Data
  class SecurityDefinitions < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#securityDefinitionsObject
    
    def initialize
      @security = {}
    end

    def self.parse(security)
      return nil unless security

      params = Swagger::Data::SecurityDefinitions.new

      security.each do |pname, pvalue|
        params.add_param(pname, pvalue)
      end

      params
    end

    def add_param(pname, pvalue)
      raise ArgumentError.new("Swagger::Data::SecurityDefinitions#add_param - parameter name is nil") unless pname
      raise ArgumentError.new("Swagger::Data::SecurityDefinitions#add_param - parameter value is nil") unless pvalue

      if !pvalue.is_a?(Swagger::Data::SecurityScheme)
        pvalue = Swagger::Data::SecurityScheme.parse(pvalue)
      end

      @security[pname] = pvalue
    end

    def [](pname)
      @security[pname]
    end

    def as_swagger
      swagger_params = {}

      @security.each do |p_k, p_v|
        swagger_params[p_k] = p_v.to_swagger
      end

      swagger_params
    end

  end
end