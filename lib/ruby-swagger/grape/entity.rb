require 'ruby-swagger/grape/entity_exposure'
require 'ruby-swagger/grape/entity_nesting_exposure'

module Swagger::Grape
  class Entity
    def initialize(type)
      @type = type.to_s

      raise ArgumentError.new("Expecting a Grape::Entity - Can't translate this!") unless Object.const_get(@type) < Grape::Entity

      @swagger_type = { 'type' => 'object', 'properties' => {} }
    end

    def to_swagger
      root_exposures.each do |exposure|
        @swagger_type['properties'].merge!(Swagger::Grape::EntityExposure.new(exposure).to_swagger)
      end

      @swagger_type
    end

    def sub_types
      root_exposures.each_with_object([]) do |exposure, collection|
        exposure = Swagger::Grape::EntityExposure.new(exposure)
        collection << exposure.sub_type if exposure.sub_type

        exposure.nested_exposures.each do |nested_exposure|
          nested_exposure = Swagger::Grape::EntityExposure.new(nested_exposure)
          collection << nested_exposure.sub_type if nested_exposure.sub_type
        end if exposure.nested?
      end.uniq
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
