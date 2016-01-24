module Swagger::Grape
  class EntityExposure
    def initialize(exposure)
      raise ArgumentError.new("Expecting a Grape::Entity::Exposure - Can't translate #{exposure}!") unless exposure.is_a? Grape::Entity::Exposure::Base

      @exposure = exposure
      @swagger_type = { attribute => {} }
    end

    def to_swagger
      translate
    end

    def sub_type
      options[:using] if representer?
    end

    def nested?
      options[:nesting] || false
    end

    def array?
      type == 'array'
    end

    def representer?
      @exposure.is_a? Grape::Entity::Exposure::RepresentExposure
    end

    def type?
      type.present?
    end

    def nested_exposures
      nested? ? @exposure.nested_exposures : nil
    end

    def type
      documentation[:type].to_s.downcase if documentation[:type].present?
    end

    def attribute
      options[:as].present? ? options[:as].to_s : @exposure.attribute.to_s
    end

    def options
      @exposure.send(:options)
    rescue
      {}
    end

    def documentation
      @exposure.documentation || {}
    rescue
      {}
    end

    def description
      @exposure.documentation[:desc] if @exposure.documentation[:desc].present?
    end

    private

    def translate
      nested? ? translate_nesting_exposure : translate_exposure
    end

    def to_swagger_type(property)
      @swagger_type[attribute].merge!(property)
      @swagger_type
    end

    def translate_nesting_exposure
      to_swagger_type(Swagger::Grape::EntityNestingExposure.new(@exposure).to_swagger)
    end

    def translate_exposure
      to_swagger_type(Type.new(type).to_swagger(true)) if type?

      if representer?
        # it's either an object or an array of object
        using = Type.new(options[:using].to_s).to_swagger(true)

        if array?
          to_swagger_type('items' => using)
        else
          to_swagger_type(using)
        end
      end

      @swagger_type[attribute]['description'] = documentation[:desc] if documentation[:desc].present?
      @swagger_type[attribute]['type'] ||= 'string' # no type defined, assuming it's a string
      @swagger_type
    end
  end
end
