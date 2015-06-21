require 'ruby-swagger/object'
require 'ruby-swagger/data/external_documentation'
require 'ruby-swagger/data/responses'
require 'ruby-swagger/data/security_requirement'

module Swagger::Data
  class Operation < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#operationObject

    attr_swagger :tags, :summary, :description, :externalDocs, :operationId,
                 :consumes, :produces, :parameters, :responses,
                 :schemes, :deprecated, :security

    def self.parse(operation)
      return unless operation

      Swagger::Data::Operation.new.bulk_set(operation)
    end

    def externalDocs=(newDoc)
      return nil unless newDoc

      unless newDoc.is_a?(Swagger::Data::ExternalDocumentation)
        newDoc = Swagger::Data::ExternalDocumentation.parse(newDoc)
      end

      @externalDocs=newDoc
    end

    def responses=(newResp)
      return nil unless newResp

      unless newResp.is_a?(Swagger::Data::Responses)
        newResp = Swagger::Data::Responses.parse(newResp)
      end

      @responses = newResp
    end

    def security=(newSecurity)
      return nil unless newSecurity

      @security = []

      newSecurity.each do |sec_object|
        unless sec_object.is_a?(Swagger::Data::SecurityRequirement)
          sec_object = Swagger::Data::SecurityRequirement.parse(sec_object)
        end

        @security.push(sec_object)
      end
    end

    def parameters=(newParams)
      return nil unless newParams

      @parameters = []

      newParams.each do |parameter|
        add_parameter(parameter)
      end
    end

    def add_parameter(new_parameter)
      @parameters ||= []

      if new_parameter.is_a?(Hash)

        new_parameter = if new_parameter['$ref']
                            #it's a reference object
                            Swagger::Data::Reference.parse(new_parameter)
                        else
                            #it's a parameter object
                            Swagger::Data::Parameter.parse(new_parameter)
                        end

      end

      @parameters.push(new_parameter)
    end

    def self.from_grape(route_name, route)
      operation = Swagger::Data::Operation.new
      operation.tags = grape_tags(route_name, route)

      operation.summary = route.route_description
      operation.description = (route.route_detail && route.route_detail.length > 0) ? route.route_detail : route.route_description

      params = {}
      route_name.scan(/\{[a-zA-Z0-9\-\_]+\}/).each do |parameter| #scan all parameters in the url
        param_name = parameter[1..parameter.length-2]
        params[param_name] = {'name' => param_name, 'in' => 'path', 'required' => true, 'type' => 'string'}
      end

      route.route_params.each do |parameter|
        swag_param = Swagger::Data::Parameter.from_grape(parameter)
        next unless swag_param

        params[parameter.first.to_s] = swag_param
      end

      params.each do |param_name, parameter|
        operation.add_parameter(parameter)
      end

      operation.responses = Swagger::Data::Responses.new

      #Long TODO - document here all the possible responses
      operation.responses.add_response('200', Swagger::Data::Response.parse({'description' => 'Successful operation'}))
      operation.responses.add_response('default', Swagger::Data::Response.parse({'description' => 'Unexpected error'}))

      operation.deprecated = route.route_deprecated if route.route_deprecated  #grape extension

      if route.route_scopes #grape extensions
        security = Swagger::Data::SecurityRequirement.new
        route.route_scopes.each do |name, requirements|
          security.add_requirement(name, requirements)
        end

        operations.security = route.route_scopes
      end

      operation
    end

    private

    def self.grape_tags(route_name, route)
      route.route_tags || [route_name.split('/')[1]]
    end


  end
end