module Swagger::Grape
  class Entity
    def initialize(type)
      raise ArgumentError.new("Expecting a Grape::Entity - Can't translate this!") unless Object.const_get(type) < Grape::Entity

      @type = type
      @swagger_type = { 'type' => 'object', 'properties' => {} }
    end

    def to_swagger
      root_exposures.each do |exposure|
        @swagger_type['properties'].merge!(Swagger::Grape::EntityExposure.new(exposure).to_swagger)
      end
      @swagger_type
    end

    def sub_types
      collection = []
      root_exposures.each do |exposure|
        exposure = Swagger::Grape::EntityExposure.new(exposure)
        collection << exposure.sub_type if exposure.sub_type

        exposure.nested_exposures.each do |nested_exposure|
          nested_exposure = Swagger::Grape::EntityExposure.new(nested_exposure)
          collection << nested_exposure.sub_type if nested_exposure.sub_type
        end if exposure.nested?
      end
      collection.uniq
    end

    private

    def root_exposures
      entity_class.root_exposures
    end

    def entity_class
      Object.const_get(@type)
    end
  end
end
