require 'ruby-swagger/object'

module Swagger::Data
  class SecurityRequirement < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#securityRequirementObject

    @requirements = {}

    def self.parse(security)
      return nil unless security

      s = Swagger::Data::SecurityRequirement.new
      security.each {|key, reqs| s.add_requirement(key, reqs)}
      s
    end

    def add_requirement(key, requirements)
      raise (ArgumentError.new("key is nil [#{Swagger::Data::SecurityRequirement._desc}]")) unless key
      raise (ArgumentError.new("requirements is nil [#{Swagger::Data::SecurityRequirement._desc}]")) unless requirements
      raise (ArgumentError.new("requirements is not an array [#{Swagger::Data::SecurityRequirement._desc}]")) unless requirements.is_a?(Array)

      @requirements[key] = requirements
    end


    def as_swagger
      @requirements
    end

  end
end