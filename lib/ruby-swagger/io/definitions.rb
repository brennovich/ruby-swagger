require 'ruby-swagger/io/file_system'
require 'ruby-swagger/io/comparable'

module Swagger::IO
  class Definitions
    def self.read_definitions
      definitions = {}

      Swagger::IO::FileSystem.all_files('definitions/**/*.yml').each do |file|
        definitions[File.basename(file, '.yml')] = YAML.load_file(file)
      end

      definitions
    end

    def self.write_definitions(definitions)
      return if definitions.nil?

      # Remove dead definitions
      Swagger::IO::FileSystem.all_files('definitions/**/*.yml').each do |file|
        def_name = File.basename(file, '.yml')

        unless definitions[def_name]
          STDERR.puts "#{def_name} is not present anymore, removing #{file}"
          Swagger::IO::FileSystem.delete_file(file)
        end
      end

      # Write new definitions
      definitions.each do |definition_name, definition|
        # If an old definition exists, we copy over the documentation to the generated definition
        if Swagger::IO::FileSystem.file_exists?("definitions/#{definition_name}.yml")
          old_definition = Swagger::IO::FileSystem.read_file("definitions/#{definition_name}.yml")

          Swagger::IO::Comparable.copy_description_old_definition(definition, old_definition)
        end

        Swagger::IO::FileSystem.write_file(definition.to_yaml, "definitions/#{definition_name}.yml", true)
      end
    end
  end
end
