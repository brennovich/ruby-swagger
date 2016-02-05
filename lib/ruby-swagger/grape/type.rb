require 'ruby-swagger/grape/entity'
require 'ruby-swagger/grape/entity_exposure'
require 'ruby-swagger/grape/entity_nesting_exposure'

module Swagger::Grape
  class Type
    attr_reader :discovered_types # needed?

    def initialize(type)
      @type = type.to_s || 'String'
    end

    def to_swagger(with_definition = true)
      translate(with_definition)
    end

    def sub_types
      Swagger::Grape::Entity.new(@type).sub_types
    end

    private

    def translate(with_definition)
      swagger_type = {}

      # basic type
      if basic_type?
        swagger_type = basic_type_schemes[@type.downcase]

      # grape shorthand array eg. `Array[Integer]`
      elsif short_hand_array?
        swagger_type = shorthand_array_scheme

      # representer or entity object
      else
        if with_definition
          # I can just reference the name of the representer here
          swagger_type = {
            'type' => 'object',
            '$ref' => "#/definitions/#{@type}"
          }

        # grape-entity object
        else
          swagger_type = Swagger::Grape::Entity.new(@type).to_swagger
        end
      end
      swagger_type
    end

    def short_hand_array?
      !(@type.downcase =~ /\[[a-zA-Z]+\]/).nil?
    end

    def basic_type?
      basic_type_schemes.key? @type.downcase
    end

    def shorthand_array_scheme
      match = @type.downcase.match(/\[(.*?)\]/)
      @swagger_type = {
        'type' => 'array',
        'items' => {
          'type' => match[1]
        }
      }
    end

    def basic_type_schemes
      {
        'string' => {
          'type' => 'string'
        },
        'integer' => {
          'type' => 'integer'
        },
        'array' => {
          'type' => 'array',
          'items' => { 'type' => 'string' }
        },
        'hash' => {
          'type' => 'object',
          'properties' => {}
        },
        'boolean' => {
          'type' => 'boolean'
        },
        'virtus::attribute::boolean' => {
          'type' => 'boolean'
        },
        'symbol' => {
          'type' => 'string'
        },
        'float' => {
          'type' => 'number',
          'format' => 'float'
        },
        'rack::multipart::uploadedfile' => {
          'type' => 'string' # 'Warning - I have no idea how to handle the type file. Right now I will consider this a string, but we should probably handle it...'
        },
        'date' => {
          'type' => 'string',
          'format' => 'date'
        },
        'datetime' => {
          'type' => 'string',
          'format' => 'date-time'
        }

      }.freeze
    end
  end
end
