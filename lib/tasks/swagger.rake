require 'ruby-swagger/io/file_system'
require 'ruby-swagger/template'

namespace :swagger do

  namespace :grape do

    desc 'Generate a swagger meta documentation from Grape API definition and store it under doc/swagger'
    task :generate_doc do
      puts "Exporting from Grape"

      swagger_doc = Swagger::Data::Template.generate

      # Get path data from Grape

      Swagger::IO::FileSystem.new(swagger_doc).write!
      puts "You should check your swagger meta documentation under #{Swagger::IO::FileSystem.default_path}"
    end

  end

  desc 'Generate a swagger 2.0-compatible documentation from the metadata stored into doc/swagger'
  task :compile_doc do
    puts "Compiling documentation"

    Swagger::IO::FileSystem.new(Swagger::IO::FileSystem.read).compile!

    puts "Done. Your documentation file is #{Swagger::IO::FileSystem.default_path}swagger.json"
  end

end
