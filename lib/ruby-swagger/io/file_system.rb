require 'ruby-swagger/object'
require 'ruby-swagger/data/document'
require 'ruby-swagger/io/security'
require 'ruby-swagger/io/definitions'
require 'ruby-swagger/io/paths'

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
      YAML.load(ERB.new(File.read(@@default_path + '/' + name)).result)
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

    def self.all_files(pattern)
      Dir["#{@@default_path}/#{pattern}"]
    end

    def self.delete_file(file)
      FileUtils.rm_f(file)
    end

    def initialize(swagger_doc)
      @doc = swagger_doc
    end

    def write!
      Swagger::IO::FileSystem.init_fs_structure

      swagger = @doc.to_swagger

      Swagger::IO::Paths.write_paths(swagger.delete('paths'))

      DOC_SUBPARTS.each {|doc_part| write_subpart(doc_part, swagger.delete(doc_part))}
      Swagger::IO::Definitions.write_definitions(swagger.delete('definitions'))
      Swagger::IO::Security.write_security_definitions(swagger.delete('securityDefinitions'))
      Swagger::IO::FileSystem.write_file(swagger.to_yaml, 'base_doc.yml')
    end

    def self.read
      doc = read_file('base_doc.yml')

      DOC_SUBPARTS.each do |doc_part|
        file_name = "#{doc_part}.yml"
        doc[doc_part] = read_file(file_name) if File.exist?("#{default_path}/#{file_name}")
      end

      doc['paths'] = Swagger::IO::Paths.read_paths
      doc['definitions'] = Swagger::IO::Definitions.read_definitions
      doc['securityDefinitions'] = Swagger::IO::Security.read_security_definitions
 
      Swagger::Data::Document.parse(doc)
    end

    def compile!
      Swagger::IO::FileSystem.write_file(JSON.pretty_generate(@doc.to_swagger), 'swagger.json', true)
    end

    private

    def write_subpart(subpart, content)
      return unless content
      write_file(content.to_yaml, "#{subpart}.yml")
    end

  end
end
