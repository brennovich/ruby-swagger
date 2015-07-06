module Swagger::Grape
  class Type

    def initialize(type)
      @type = type.to_s || 'String'
    end

    def to_swagger(with_definition = true)
      swagger_type = {}

      case @type.downcase
        when 'string'
          swagger_type['type'] = 'string'
        when 'integer'
          swagger_type['type'] = 'integer'
        when 'array'
          swagger_type['type'] = 'array'
          swagger_type['items'] = {'type' => 'string'}
        when 'hash'
          swagger_type['type'] = 'object'
          swagger_type['properties'] = {}
        when 'virtus::attribute::boolean'
          swagger_type['type'] = 'boolean'
        when 'symbol'
          swagger_type['type'] = 'string'
        when 'float'
          swagger_type['type'] = 'number'
          swagger_type['format'] = 'float'
        when 'rack::multipart::uploadedfile'
          swagger_type['type'] = 'file'
        when 'date'
          swagger_type['type'] = 'date'
        when 'datetime'
          swagger_type['format'] = 'date-time'
          swagger_type['format'] = 'string'
        else
          swagger_type['type'] = "object"
          swagger_type['schema'] = {"$ref" => "#/definitions/#{@type}"}
      end

      swagger_type
    end

  end
end