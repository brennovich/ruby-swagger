require 'ruby-swagger/object'
require 'ruby-swagger/data/document'
require 'ruby-swagger/io/security'
require 'ruby-swagger/io/writer'

module Swagger::IO
  class FileSystem

    DOC_SUBPARTS = %w(responses security tags)

    @@default_path = './doc/swagger'

    def self.default_path=(new_path)
      @@default_path = new_path
    end

    def self.default_path
      @@default_path
    end

    def self.init_fs_structure
      FileUtils.mkdir_p(@@default_path) unless Dir.exists?(@@default_path)
    end

    def self.read_file(name)
      YAML::load_file(@@default_path + '/' + name)
    end

    def self.write_file(content, location, overwrite = false)
      file_path = @@default_path + '/' + location

      return if !overwrite && File.exists?(file_path)

      dir_path = File.dirname(file_path)

      FileUtils.mkdir_p(dir_path) unless Dir.exists?(dir_path)
      File.open(file_path, 'w') {|f| f.write(content) }
    end

    def self.file_exists?(name)
      File.exists?(@@default_path + '/' + name)
    end

    def initialize(swagger_doc)
      @doc = swagger_doc
    end

    def write!
      Swagger::IO::FileSystem.init_fs_structure

      swagger = @doc.to_swagger

      write_paths(swagger.delete('paths'))

      DOC_SUBPARTS.each do |doc_part|
        write_subpart(doc_part, swagger.delete(doc_part))
      end

      if swagger['definitions']
        write_definitions(swagger.delete('definitions'))
      end

      if swagger['securityDefinitions']
        Swagger::IO::Security.write_security_definitions(swagger.delete('securityDefinitions'))
      end

      Swagger::IO::FileSystem.write_file(swagger.to_yaml, 'base_doc.yml')
    end

    def self.read
      doc = YAML::load_file("#{default_path}/base_doc.yml")

      DOC_SUBPARTS.each do |doc_part|
        file_path = "#{default_path}/#{doc_part}.yml"
        doc[doc_part] = YAML::load_file(file_path) if File.exists?(file_path)
      end

      doc['paths'] = read_paths("#{default_path}/paths/")
      doc['definitions'] = read_definitions("#{default_path}/definitions/")
      doc['securityDefinitions'] = read_security_definitions("#{default_path}/")
 
      Swagger::Data::Document.parse(doc)
    end

    def compile!
      Swagger::IO::FileSystem.write_file(JSON.pretty_generate(@doc.to_swagger), 'swagger.json', true)
    end

    private

    def self.read_paths(base)
      paths = {}
      all_files = Dir["#{base}/**/*.yml"]
      l = base.length

      all_files.each do |file|
        content = YAML::load_file(file)
        paths[File.dirname(file[l..file.length])] ||= {}
        paths[File.dirname(file[l..file.length])][File.basename(file, ".yml")] = content
      end

      paths
    end

    def self.read_definitions(base)
      definitions = {}
      all_files = Dir["#{base}/**/*.yml"]

      all_files.each do |file|
        content = YAML::load_file(file)
        definitions[File.basename(file, ".yml")] = content
      end

      definitions
    end

    def self.read_security_definitions(base)
      return nil unless File.exists?("#{base}/securityDefinitions.yml")
      definitions = YAML::load_file("#{base}/securityDefinitions.yml")

      all_files = Dir["#{base}/scopes/*.yml"]

      all_files.each do |file|
        content = YAML::load_file(file)
        definitions[File.basename(file, ".yml")]['scopes'] = content
      end

      definitions
    end



    def write_definitions(definitions)
      definitions.each do |definition_name, definition|
        Swagger::IO::FileSystem.write_file(definition.to_yaml, "definitions/#{definition_name}.yml", true)
      end
    end

    def write_paths(paths)
      paths.each do |path, path_obj|
        path_obj.each do |action, action_obj|
          Swagger::IO::FileSystem.write_file(action_obj.to_yaml, "paths/#{path}/#{action}.yml", true)
        end
      end
    end

    def write_subpart(subpart, content)
      return unless content
      write_file(content.to_yaml, "#{subpart}.yml")
    end

  end
end