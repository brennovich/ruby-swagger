require 'ruby-swagger/io/file_system'
require 'ruby-swagger/grape/grape_template'

namespace :swagger do

  namespace :grape do

    unless defined?(Rails)
      task :environment do
        # for non-rails environment, we do not load the env
      end
    end

    desc 'Generate a swagger meta documentation from Grape API definition and store it under doc/swagger'
    task :generate_doc, [:base_class] => :environment do |t, args|
      if args[:base_class].nil?
        STDERR.puts "You need to pass a base class for your API"
        STDERR.puts "For example: rake 'swagger:grape:generate_doc[ApiBase]'"
        exit -1
      end

      puts "Exporting from Grape - base class #{args[:base_class]}"

      swagger_doc = Swagger::Grape::Template.generate(Module.const_get(args[:base_class]))

      # Get path data from Grape

      Swagger::IO::FileSystem.new(swagger_doc).write!
      puts "You should check your swagger meta documentation under #{Swagger::IO::FileSystem.default_path}"
    end

  end

  desc 'Generate a swagger 2.0-compatible documentation from the metadata stored into doc/swagger'
  task :compile_doc do
    puts "Compiling documentation"

    Swagger::IO::FileSystem.new(Swagger::IO::FileSystem.read).compile!

    puts "Done. Your documentation file is #{Swagger::IO::FileSystem.default_path}/swagger.json"
  end

end
