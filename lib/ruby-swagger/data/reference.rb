require 'ruby-swagger/object'

module Swagger::Data
  class Reference < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#referenceObject
    @ref = nil

    def self.parse(reference)
      return nil unless reference

      r = Swagger::Data::Reference.new
      r.ref = reference['$ref']
      r
    end

    def ref=(new_ref)
      raise (ArgumentError.new('Swagger::Data::Reference#ref= $ref is nil')) unless new_ref
      @ref = new_ref
    end

    attr_reader :ref

    def as_swagger
      @ref.nil? ? {} : { '$ref' => @ref }
    end
  end
end
