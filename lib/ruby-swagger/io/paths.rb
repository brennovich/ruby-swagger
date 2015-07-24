require 'ruby-swagger/io/file_system'

module Swagger::IO
  class Paths

    def self.read_paths
      paths = {}

      l = (Swagger::IO::FileSystem.default_path + '/paths').length

      Swagger::IO::FileSystem.all_files('paths/**/*.yml').each do |file|
        content = YAML::load_file(file)
        paths[File.dirname(file[l..file.length])] ||= {}
        paths[File.dirname(file[l..file.length])][File.basename(file, ".yml")] = content
      end

      paths
    end

    def self.write_paths(paths)
      return if paths.nil?

      l = (Swagger::IO::FileSystem.default_path + '/paths').length

      #Remove dead endpoints
      Swagger::IO::FileSystem.all_files("paths/**/*.yml").each do |file|
        def_name = file[l..file.length]

        if paths[File.dirname(file[l..file.length])].nil? || paths[File.dirname(file[l..file.length])][File.basename(file, ".yml")].nil?
          STDERR.puts "#{def_name} is not present anymore, removing #{file}"
          Swagger::IO::FileSystem.delete_file(file)
        end

      end

      paths.each do |path, path_obj|
        path_obj.each do |action, action_obj|

          file = "paths/#{path}/#{action}.yml"

          # If an old definition exists, we copy over the documentation to the generated definition
          if Swagger::IO::FileSystem.file_exists?(file)
            old_action = Swagger::IO::FileSystem.read_file(file)

            Swagger::IO::Comparable.copy_description_old_definition(action_obj, old_action)
          end


          Swagger::IO::FileSystem.write_file(action_obj.to_yaml, file, true)
        end
      end
    end

  end
end