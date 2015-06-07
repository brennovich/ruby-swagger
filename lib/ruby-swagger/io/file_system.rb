require 'ruby-swagger/object'

module Swagger::IO
  class FileSystem

    @@default_path = './doc/swagger'

    def self.default_path=(new_path)
      @@default_path = new_path
    end

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
      FileUtils.mkdir_p(@@default_path) unless Dir.exists?(@@default_path)

      #@doc.swagger
    end

    def read
      raise "not implemented"
    end

    def compile!
      raise "not implemented"
    end

  end
end