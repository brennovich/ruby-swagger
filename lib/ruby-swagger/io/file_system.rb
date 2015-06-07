require 'ruby-swagger/object'

module Swagger::IO
  class FileSystem

    DEFAULT_PATH = './doc/swagger'

    def initialize(swagger_doc, format = :yaml)
      @doc = swagger_doc
      @format = case format
        when 'yaml', :yaml
          :yaml
        when 'json', :json
          :json
        else
          raise ArgumentError.new("Unrecognized format [#{format}]")
      end
    end

    def write!
      Dir.mkdir(DEFAULT_PATH) unless Dir.exists?(DEFAULT_PATH)

      @doc.swagger
    end

    def read
      raise "not implemented"
    end

    def compile!
      raise "not implemented"
    end

  end
end