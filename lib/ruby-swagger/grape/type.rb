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

      return [] unless type <= Grape::Entity

      types = []

      type.root_exposures.each do |property|
        options = exposure_options(property)
        types << options[:using] if options[:using].present?

        next unless property.is_a?(Grape::Entity::Exposure::NestingExposure)

        property.nested_exposures.each do |nested_property|
          options = exposure_options(nested_property)
          types << options[:using] if options[:using].present?
        end
      end
      types.uniq
    end

    private

    def exposure_options(exposure)
      exposure.send(:options)
    rescue
      []
    end

    def type_convert(type, with_definition = true)
      swagger_type = {}
      case type.downcase
      when 'string'
        swagger_type['type'] = 'string'
      when 'integer'
        swagger_type['type'] = 'integer'
      when 'array'
        swagger_type['type'] = 'array'
        swagger_type['items'] = { 'type' => 'string' }
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
        STDERR.puts 'Warning - I have no idea how to handle the type file. Right now I will consider this a string, but we should probably handle it...'
      when 'date'
        swagger_type['type'] = 'string'
        swagger_type['format'] = 'date'
      when 'datetime'
        swagger_type['type'] = 'string'
        swagger_type['format'] = 'date-time'
      else
        swagger_type['type'] = 'object'

        if with_definition
          # I can just reference the name of the object here
          swagger_type['$ref'] = "#/definitions/#{type}"
        else
          type = Object.const_get(@type)
          # I need to define the full object
          raise ArgumentError.new("Don't know how to translate the object #{@type}") unless type.respond_to?(:root_exposures)

          swagger_type['properties'] = {}

          swagger_type = process_exposures(type.root_exposures, swagger_type)
        end
      end

      swagger_type
    end

    def process_exposures(exposures, swagger_type)
      exposures.each do |exposure|
        swagger_type['properties'].merge!(translate_property(exposure))
      end

      swagger_type
    end

    def translate_property(exposure)
      property = {}
      options = exposure.send(:options)
      target = options[:as].present? ? options[:as].to_s : exposure.attribute.to_s

      property[target] = {}

      # process nested exposures
      if exposure.is_a?(Grape::Entity::Exposure::NestingExposure)

        property[target].merge!('type' => 'object', 'properties' => {})

        exposure.nested_exposures.each do |prop|
          property[target]['properties'].merge!(translate_property(prop))
        end
      # process top level exposures
      else
        if options[:documentation].present? && options[:documentation][:type].present?
          property[target].merge!(type_convert(options[:documentation][:type].to_s, true))
        end

        if options[:using].present?
          # it's either an object or an array of object
          using = type_convert(options[:using].to_s, true)

          if options[:documentation].present? &&
             options[:documentation][:type].present? &&
             options[:documentation][:type].to_s.downcase == 'array'
            property[target]['items'] = using
          else
            property[target] = using
          end
        end

        property[target]['description'] = options[:documentation][:desc] if options[:documentation].present?
        property[target]['type'] ||= 'string' # no type defined, assuming it's a string

      end
      property
    end
  end
end
