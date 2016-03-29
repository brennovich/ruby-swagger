module Swagger
  module Grape
    class Representer
      def initialize(type)
        @type = type

        unless representer < Representable || coercion?
          raise ArgumentError.new("Expecting a Representable - Can't translate this!")
        end
      end

      def to_swagger
        if representer.respond_to?(:representable_attrs)
          @swagger_definition ||= { 'type' => 'object', 'properties' => properties }
        else
          Type.new(String).to_swagger(false)
        end
      end

      def sub_types
        return [] if coercion?

        definitions.flat_map do |definition, _|
          options = definition.instance_variable_get(:@options)

          if options[:_inline]
            self.class.new(options[:extend]).sub_types
          else
            options[:extend] || options[:type]
          end
        end.compact.reject { |type| type.is_a?(String) }.uniq
      end

      private

      attr_reader :type

      def properties
        definitions.each_with_object({}) do |definition, properties|
          options = definition.instance_variable_get(:@options)

          if options[:_inline]
            swagger_definition = self.class.new(options[:extend]).to_swagger
            swagger_definition = collection_properties(swagger_definition) if options[:collection]
          else
            custom_definition = options[:extend] || options[:type]
            swagger_definition = Type.new(custom_definition).to_swagger(!runtime_definition?(custom_definition))
          end

          properties[options[:as]] = swagger_definition
          properties[options[:as]].merge!('description' => options[:desc]) if options[:desc]
        end
      end

      def collection_properties(items_definition)
        { 'type' => 'array', 'items' => items_definition }
      end

      def definitions
        representer.representable_attrs[:definitions].except('links')
      end

      def coercion?
        representer < Virtus::Attribute
      end

      def runtime_definition?(definition)
        definition.to_s.include?('Class') || representer.to_s.include?('Class')
      end

      def representer
        @representer ||= type.is_a?(String) ? Object.const_get(type) : type
      end
    end
  end
end
