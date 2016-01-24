require 'ruby-swagger/grape/entity'
require 'ruby-swagger/grape/entity_exposure'
require 'ruby-swagger/grape/entity_nesting_exposure'

module Swagger::Grape
  class Type
    attr_reader :discovered_types # needed?

    def initialize(type)
      @type = type.to_s || 'String'
      @swagger_type = {}
    end

    def to_swagger(with_definition = true)
      translate(@type, with_definition)
    end

    def sub_types
      Swagger::Grape::Entity.new(@type).sub_types
    end

    private

    def translate(type, with_definition)
      case type.downcase
      when 'string'
        @swagger_type['type'] = 'string'
      when 'integer'
        @swagger_type['type'] = 'integer'
      when 'array'
        @swagger_type['type'] = 'array'
        @swagger_type['items'] = { 'type' => 'string' }
      when 'hash'
        @swagger_type['type'] = 'object'
        @swagger_type['properties'] = {}
      when 'boolean'
        @swagger_type['type'] = 'boolean'
      when 'virtus::attribute::boolean'
        @swagger_type['type'] = 'boolean'
      when 'symbol'
        @swagger_type['type'] = 'string'
      when 'float'
        @swagger_type['type'] = 'number'
        @swagger_type['format'] = 'float'
      when 'rack::multipart::uploadedfile'
        @swagger_type['type'] = 'string'
        STDERR.puts 'Warning - I have no idea how to handle the type file. Right now I will consider this a string, but we should probably handle it...'
      when 'date'
        @swagger_type['type'] = 'string'
        @swagger_type['format'] = 'date'
      when 'datetime'
        @swagger_type['type'] = 'string'
        @swagger_type['format'] = 'date-time'
      else

        if with_definition
          # I can just reference the name of the object here
          @swagger_type['type'] = 'object'
          @swagger_type['$ref'] = "#/definitions/#{type}"
        else
          @swagger_type = Swagger::Grape::Entity.new(type).to_swagger
        end
      end
      @swagger_type
    end
  end
end
