require 'ruby-swagger/data/operation'

module Swagger::Grape
  class Method

    attr_reader :operation

    def initialize(route_name, route)
      @route_name = route_name
      @route = route

      new_operation
      operation_params
      operation_responses
      operation_security

      self
    end

    private

    #generate the base of the operation
    def new_operation
      @operation = Swagger::Data::Operation.new
      @operation.tags = grape_tags
      @operation.operationId = @route.route_api_name if @route.route_api_name && @route.route_api_name.length > 0
      @operation.summary = @route.route_description
      @operation.description = (@route.route_detail && @route.route_detail.length > 0) ? @route.route_detail : @route.route_description
      @operation.deprecated = @route.route_deprecated if @route.route_deprecated  #grape extension

      @operation
    end

    def operation_params
      extract_params_and_types

      @params.each do |param_name, parameter|
        operation.add_parameter(parameter)
      end
    end


    def operation_responses
      @operation.responses = Swagger::Data::Responses.new

      #Long TODO - document here all the possible responses
      @operation.responses.add_response('200', Swagger::Data::Response.parse({'description' => 'Successful operation'}))
      @operation.responses.add_response('default', Swagger::Data::Response.parse({'description' => 'Unexpected error'}))
    end

    def operation_security
      # if route.route_scopes #grape extensions
      #   security = Swagger::Data::SecurityRequirement.new
      #   route.route_scopes.each do |name, requirements|
      #     security.add_requirement(name, requirements)
      #   end
      #
      #   operations.security = route.route_scopes
      # end
    end

    #extract the tags
    def grape_tags
      (@route.route_tags && !@route.route_tags.empty?) ? @route.route_tags : [@route_name.split('/')[1]]
    end

    def extract_params_and_types
      @params, @types = {}, []

      header_params
      path_params

      case @route.route_method.downcase
        when 'get'
          query_params
        when 'delete'
          query_params
        when 'post'
          body_params
       when 'put'
          body_params
        when 'patch'
          body_params
        when 'head'
          raise ArgumentError.new("Don't know how to handle the http verb HEAD for #{@route_name}")
        else
          raise ArgumentError.new("Don't know how to handle the http verb #{@route.route_method} for #{@route_name}")
      end

      @params
    end

    def header_params
      @params ||= {}

      #include all the parameters that are in the headers
      if @route.route_headers
        @route.route_headers.each do |header_key, header_value|
          @params[header_key] = {'name' => header_key,
                                'in' => 'header',
                                'required' => (header_value[:required] == true),
                                'type' => 'string',
                                'description' => header_value[:description]}
        end
      end

      @params
    end

    def path_params
      #include all the parameters that are in the path

      @route_name.scan(/\{[a-zA-Z0-9\-\_]+\}/).each do |parameter| #scan all parameters in the url
        param_name = parameter[1..parameter.length-2]
        @params[param_name] = {'name' => param_name,
                               'in' => 'path',
                               'required' => true,
                               'type' => 'string'}
      end

    end

    def query_params
      @route.route_params.each do |parameter|
        swag_param = Swagger::Data::Parameter.from_grape(parameter)
        next unless swag_param

        @params[parameter.first.to_s] = swag_param
      end
    end

    def body_params
      #include all the parameters that are in the content-body
      return unless @route.route_params && @route.route_params.length > 0

      root_param = Swagger::Data::Parameter.parse({'name' => 'body',
                                                   'in' => 'body',
                                                   'description' => 'the content of the request',
                                                   'schema' => {'type' => 'object', 'properties' => {}}})

      #create the params schema
      @route.route_params.each do |parameter|
        param_name = parameter.first
        param_value = parameter.last
        schema = root_param.schema

        next if @params.keys.include?(param_name)

        if param_name.scan(/[0-9a-zA-Z_]+/).count == 1
          #it's a simple parameter, adding it to the properties of the main object
          schema.properties[param_name] = grape_param_to_swagger(param_value)
          required_parameter(schema, param_name, param_value)
        else
          schema_with_subobjects(schema, param_name, parameter.last)
        end

      end

      schema= root_param.schema
      @params['body'] = root_param if !schema.properties.nil? && schema.properties.keys.length > 0
    end

    def required_parameter(schema, name, parameter)
      return if parameter.nil? || parameter[:required].nil? || parameter[:required] == false

      schema['required'] ||= []
      schema['required'] << name
    end

    def schema_with_subobjects(schema, param_name, parameter)
      path = param_name.scan(/[0-9a-zA-Z_]+/)
      append_to = find_elem_in_schema(schema, path.dup)
      append_to['properties'][path.last] = grape_param_to_swagger(parameter)

      required_parameter(append_to, path.last, parameter)
    end

    def find_elem_in_schema(root, schema_path)
      return root if schema_path.nil? || schema_path.empty?

      next_elem = schema_path.shift

      return root if root['properties'][next_elem].nil?

      case root['properties'][next_elem]['type']
        when 'array'
          #to descend an array this must be an array of objects
          root['properties'][next_elem]['items']['type'] = 'object'
          root['properties'][next_elem]['items']['properties'] ||= {}

          find_elem_in_schema(root['properties'][next_elem]['items'], schema_path)
        when 'object'
          find_elem_in_schema(root['properties'][next_elem], schema_path)
        else
          raise ArgumentError.new("Don't know how to handle the schema path #{schema_path.join('/')}")
      end

    end

    def grape_param_to_swagger(param)
      type = (param[:type] && param[:type].downcase) || 'string'

      response = {}
      response['description'] = param[:desc] if param[:desc].present?
      response['default'] = param[:default] if param[:default].present?

      case type
        when 'string'
          response['type'] = 'string'
        when 'integer'
          response['type'] = 'integer'
        when 'array'
          response['type'] = 'array'
          response['items'] = {'type' => 'string'}
        when 'hash'
          response['type'] = 'object'
          response['properties'] = {}
        when 'virtus::attribute::boolean'
          response['type'] = 'boolean'
        when 'symbol'
          response['type'] = 'string'
        when 'float'
          response['type'] = 'number'
          response['format'] = 'float'
        when 'rack::multipart::uploadedfile'
          response['type'] = 'file'
        when 'date'
          response['type'] = 'date'
        when 'datetime'
          response['format'] = 'date-time'
          response['format'] = 'string'
        else
          raise "Don't know how to convert they grape type #{type}"
      end

      response
    end

  end
end
