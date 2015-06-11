require 'ruby-swagger/object'
require 'ruby-swagger/data/parameter'

module Swagger::Data
  class Parameters < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parametersDefinitionsObject

    def initialize
      @parameters = {}
    end

    def self.parse(parameters)
      return nil unless parameters

      params = Swagger::Data::Definitions.new

      parameters.each do |pname, pvalue|
        params.add_param(pname, pvalue)
      end

      params
    end

    def add_param(pname, pvalue)
      raise ArgumentError.new("Swagger::Data::Parameters#add_param - parameter name is nil") unless pname
      raise ArgumentError.new("Swagger::Data::Parameters#add_param - parameter value is nil") unless pvalue

      if !pvalue.is_a?(Swagger::Data::Parameter)
        pvalue = Swagger::Data::Parameter.parse(pvalue)
      end

      @parameters[pname] = pvalue
    end

    def as_swagger
      swagger_params = {}

      @parameters.each do |p_k, p_v|
        swagger_params[p_k] = p_v
      end

      swagger_params
    end

  end
end