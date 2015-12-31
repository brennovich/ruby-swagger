module Swagger::Grape
  class Type

    attr_reader :discovered_types

    def initialize(type)
      @type = type.to_s || 'String'
    end

    def to_swagger(with_definition = true)
      type_convert(@type.to_s, with_definition)
    end

    def sub_types
      type = Object.const_get(@type)
      return [] unless type.respond_to?(:exposures)

      types = []

      type.exposures.each do |property, definition|
        types << definition[:using] if definition[:using].present?
      end

      types.uniq
    end

    private

    def type_convert(type, with_definition = true)
      swagger_type = {}

      case type.downcase
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
        when 'boolean'
          swagger_type['type'] = 'boolean'
        when 'virtus::attribute::boolean'
          swagger_type['type'] = 'boolean'
        when 'symbol'
          swagger_type['type'] = 'string'
        when 'float'
          swagger_type['type'] = 'number'
          swagger_type['format'] = 'float'
        when 'rack::multipart::uploadedfile'
          swagger_type['type'] = 'string'
          STDERR.puts "Warning - I have no idea how to handle the type file. Right now I will consider this a string, but we should probably handle it..."
        when 'date'
          swagger_type['type'] = 'string'
          swagger_type['format'] = 'date'
        when 'datetime'
          swagger_type['type'] = 'string'
          swagger_type['format'] = 'date-time'
        else
          swagger_type['type'] = "object"

          if with_definition
            # I can just reference the name of the object here
            swagger_type['$ref'] = "#/definitions/#{type}"
          else
            type = Object.const_get(@type)
            # I need to define the full object
            raise ArgumentError.new("Don't know how to translate the object #{@type}") unless type.respond_to?(:exposures)

            swagger_type['properties'] = {}

            type.exposures.each do |property, definition|

              cursor = swagger_type
              target = property.to_s

              if definition[:nested]
                # it's a nested parameter
                path = target.split('__')
                cursor = find_elem_in_schema(cursor, path.dup)
                target = path.last
              end

              target = definition[:as].to_s if definition[:as].present?

              cursor['properties'][target] = {}

              if definition[:documentation].present? && definition[:documentation][:type].present?
                cursor['properties'][target] = type_convert(definition[:documentation][:type].to_s, true)
              end

              if definition[:using].present?
                #it's either an object or an array of object
                using = type_convert(definition[:using].to_s, true)
                
                if definition[:documentation][:type].present? && definition[:documentation][:type].downcase == 'array'
                  cursor['properties'][target]['items'] = using
                else
                  cursor['properties'][target] = using
                end
              end

              cursor['properties'][target]['description'] = definition[:documentation][:desc] if definition[:documentation].present?
              cursor['properties'][target]['type'] ||= 'string'  #no type defined, assuming it's a string
            end
          end
      end

      swagger_type
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
          # I'm discending an object that before I assumed was something else
          root['properties'][next_elem]['type'] = 'object'
          root['properties'][next_elem]['properties'] ||= {}

          find_elem_in_schema(root['properties'][next_elem], schema_path)
      end

    end

  end
end
