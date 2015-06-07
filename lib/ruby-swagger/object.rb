module Swagger
  class Object

    @@swagger_attribs = {}

    def self.attr_swagger(*attributes)
      attr_accessor(*attributes)
      @@swagger_attribs[self.to_s] = *attributes
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

    protected

    def as_swagger
      swagger = {}

      @@swagger_attribs[self.class.to_s].each do |property|
        obj = self.send(property)
        obj = obj.to_swagger if obj.respond_to?(:to_swagger)

        swagger[property.to_s] = obj if !obj.nil?
      end

      swagger
    end

  end
end