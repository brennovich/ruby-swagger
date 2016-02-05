require 'ruby-swagger/io/file_system'

module Swagger::IO
  class Security
    SECURITY_FILE_NAME = 'securityDefinitions.yml'

    def self.write_security_definitions(security_definitions)
      return if security_definitions.nil? || security_definitions.empty?

      security_definitions.each do |definition_name, definition|
        Swagger::IO::Security.write_scopes(definition_name, definition)
      end

      Swagger::IO::FileSystem.write_file(security_definitions.to_yaml, SECURITY_FILE_NAME)
    end

    def self.read_security_definitions
      return nil unless Swagger::IO::FileSystem.file_exists?(SECURITY_FILE_NAME)
      definitions = Swagger::IO::FileSystem.read_file(SECURITY_FILE_NAME)

      Swagger::IO::FileSystem.all_files('/scopes/*.yml').each do |file|
        definitions[File.basename(file, '.yml')]['scopes'] = YAML.load_file(file)
      end

      definitions
    end

    def self.write_scopes(definition_name, definition)
      return unless definition && definition['scopes']

      scopes = definition.delete('scopes') || {}
      scope_file = "scopes/#{definition_name}.yml"

      return Swagger::IO::FileSystem.write_file(scopes.to_yaml, scope_file) unless Swagger::IO::FileSystem.file_exists?(scope_file)

      # Merging old scopes into new scope
      old_scopes = Swagger::IO::FileSystem.read_file(scope_file)

      Swagger::IO::FileSystem.write_file(scopes.merge(old_scopes).to_yaml, scope_file, true)
    end
  end
end
