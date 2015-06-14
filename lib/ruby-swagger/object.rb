module Swagger
  class Object

    @@swagger_attribs = {}

    def self.attr_swagger(*attributes)
      attr_accessor(*attributes)
      @@swagger_attribs[self.to_s] = *attributes
    end

    def swagger_attributes
      @@swagger_attribs[self.class.to_s]
    end

    def to_json(options = nil)
      to_swagger.to_json(options)
    end

    def to_yaml
      to_swagger.to_yaml
    end

    def to_swagger
      as_swagger
    end

    def bulk_set(object)
      swagger_attributes.each do |attribute|
        self.send("#{attribute}=", object[attribute.to_s])
      end

      self
    end

    protected

    def as_swagger
      swagger = {}

      swagger_attributes.each do |property|
        obj = self.send(property)
        obj = swaggerify(obj)

        swagger[property.to_s] = obj if !obj.nil?
      end

      swagger
    end

    def swaggerify(object)
      return nil if object.nil?

      return object.to_swagger if object.respond_to?(:to_swagger)

      if object.is_a?(Array)
        object.map! do |element|
          swaggerify(element)
        end
      end

      object
    end

  end
end