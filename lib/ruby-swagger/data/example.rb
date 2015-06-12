require 'ruby-swagger/object'

module Swagger::Data
  class Example < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#exampleObject

    @examples = {}

    def self.parse(examples)
      return nil unless examples

      ex_obj = Swagger::Data::Example.new

      examples.each {|example_mime, example| ex_obj[example_mime] = example }

      ex_obj
    end

    def as_swagger
      @examples
    end

  end
end