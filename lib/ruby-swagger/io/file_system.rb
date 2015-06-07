require 'ruby-swagger/object'

module Swagger::IO
  class FileSystem

    @@default_path = './doc/swagger'

    def self.default_path=(new_path)
      @@default_path = new_path
    end

    def self.default_path
      @@default_path
    end

    def initialize(swagger_doc)
      @doc = swagger_doc
    end

    def write!
      init_fs_structure

      swagger = @doc.to_swagger
      write_file(swagger.to_yaml, 'base_doc.yaml')
    end

    def self.read
      raise "not implemented"
    end

    def compile!
      raise "not implemented"
    end

    private

    def init_fs_structure
      FileUtils.mkdir_p(@@default_path) unless Dir.exists?(@@default_path)
    end

    def write_file(content, location, overwrite = false)
      file_path = @@default_path + '/' + location

      return if !overwrite && File.exists?(file_path)

      dir_path = File.dirname(file_path);

      FileUtils.mkdir_p(dir_path) unless Dir.exists?(dir_path)
      File.open(file_path, 'w') {|f| f.write(content) }
    end

  end
end