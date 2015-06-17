require 'ruby-swagger/object'

module Swagger::Data
  class SecurityRequirement < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#securityRequirementObject

    def initialize
      @requirements = {}
    end

    def self.parse(security)
      return nil unless security

      s = Swagger::Data::SecurityRequirement.new
      security.each {|key, reqs| s.add_requirement(key, reqs)}
      s
    end

    def add_requirement(key, requirements)
      raise (ArgumentError.new("Swagger::Data::SecurityRequirement#add_requirement - key is nil")) unless key
      raise (ArgumentError.new("Swagger::Data::SecurityRequirement#add_requirement - requirements is nil")) unless requirements
      raise (ArgumentError.new("Swagger::Data::SecurityRequirement#add_requirement - requirements is not an array")) unless requirements.is_a?(Array)

      @requirements[key] = requirements
    end

    def [](key)
      @requirements[key]
    end

    def as_swagger
      @requirements
    end

  end
end