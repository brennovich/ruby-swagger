require 'ruby-swagger/grape/entity'
require 'ruby-swagger/grape/representer'

module Swagger::Grape
  class Type
    def initialize(type)
      @type = type || 'String'
    end

    def to_swagger(with_definition = true)
      translate(with_definition)
    end

    def sub_types
      return [] if basic_type?

      object_translation.sub_types
    end

    private

    attr_reader :type, :object_translator

    def translate(with_definition)
      swagger_type = {}

      # basic type
      if basic_type?
        swagger_type = basic_type_schemes[type.to_s.downcase]

      # grape shorthand array eg. `Array[Integer]`
      elsif short_hand_array?
        swagger_type = shorthand_array_scheme

      # representer or entity object
      else
        if with_definition
          # I can just reference the name of the representer here
          swagger_type = {
            'type' => 'object',
            '$ref' => "#/definitions/#{type}"
          }

        # translator object (Grape::Entity or Roar)
        else
          swagger_type = object_translation.to_swagger
        end
      end

      swagger_type
    end

    def short_hand_array?
      !(type.to_s.downcase =~ /\[[a-zA-Z]+\]/).nil?
    end

    def basic_type?
      basic_type_schemes.key? type.to_s.downcase
    end

    def shorthand_array_scheme
      match = type.to_s.downcase.match(/\[(.*?)\]/)

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

    def object_translation
      @object_translation ||= object_translator.new(type)
    end

    def object_translator
      type_class = type.is_a?(String) ? Object.const_get(type) : type

      return Entity if defined?(Grape::Entity) && type_class < Grape::Entity
      return Representer if defined?(Representable) && type_class < Representable || type_class < Virtus::Attribute
    end
  end
end
