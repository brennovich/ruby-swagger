require 'json'

module Swagger
  class Document  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#swagger-object

    SPEC_VERSION = '2.0'  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields

    attr_accessor :info

    def to_json
      {
          swagger: SPEC_VERSION,
          info: @info
      }.to_json
    end

  end
end