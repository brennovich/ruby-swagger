module Swagger::Grape
  class EntityNestingExposure < EntityExposure
    def initialize(exposure)
      raise ArgumentError.new("Expecting a NestingExposure - Can't translate #{exposure}!") unless exposure.is_a? Grape::Entity::Exposure::NestingExposure

      @exposure = exposure
      @properties = {}
    end

    def to_swagger
      nested_exposures.each do |exposure|
        @properties.merge!(Swagger::Grape::EntityExposure.new(exposure).to_swagger)
      end

      array? ? array_schema : object_schema
    end

    private

    def object_schema
      {
        'type' => 'object',
        'properties' => @properties
      }
    end

    def array_schema
      {
        'type' => 'array',
        'description' => description,
        'items' => {
          'type' => 'object',
          'properties' => @properties
        }
      }
    end
  end
end
