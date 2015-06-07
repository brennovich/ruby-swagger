module Swagger
  class IO::Writer

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
      raise "not implemented"
    end

    def read
      raise "not implemented"
    end

    def compile!
      raise "not implemented"
    end

  end
end