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

  desc 'Build an API client given the swagger definition in doc/swagger/swagger.json'
  namespace :generate_client do

    def build_client(language)
      unless File.exists?('./doc/swagger/swagger.json')
        STDERR.puts "File ./doc/swagger/swagger.json does not exist"
        exit -1
      end

      unless File.exists?('vendor/swagger-codegen-cli.jar')
        STDERR.puts "Swagger codegen does not exist, downloading it now..."
        Dir.mkdir('./vendor') unless Dir.exists?('./vendor')

        `wget -O ./vendor/swagger-codegen-cli.jar https://s3-us-west-2.amazonaws.com/tunamelt-production/swagger-codegen/swagger-codegen-cli.jar`
      end

      puts "Generating #{language} client (output in api_client/#{language})"

      FileUtils.rm_rf("./api_client/#{language}") if Dir.exists?("./api_client/#{language}")

      `java -jar ./vendor/swagger-codegen-cli.jar generate \
            -i ./doc/swagger/swagger.json \
            -l #{language} \
            -o api_client/#{language}`
    end

    desc 'Build the Ruby API client given the swagger definition in doc/swagger/swagger.json'
    task :ruby do
      build_client 'ruby'
    end

    desc 'Build the Java API client given the swagger definition in doc/swagger/swagger.json'
    task :java do
      build_client 'java'
    end

    desc 'Build the Scala API client given the swagger definition in doc/swagger/swagger.json'
    task :scala do
      build_client 'scala'
    end

    desc 'Build the Python API client given the swagger definition in doc/swagger/swagger.json'
    task :python do
      build_client 'python'
    end

    desc 'Build the Python 3 API client given the swagger definition in doc/swagger/swagger.json'
    task :python_3 do
      build_client 'python'
    end

    desc 'Build the PHP API client given the swagger definition in doc/swagger/swagger.json'
    task :php do
      build_client 'php'
    end

    desc 'Build the Perl API client given the swagger definition in doc/swagger/swagger.json'
    task :perl do
      build_client 'perl'
    end

    desc 'Build the ObjectiveC API client given the swagger definition in doc/swagger/swagger.json'
    task :objective_c do
      build_client 'objc'
    end

    desc 'Build the C# API client given the swagger definition in doc/swagger/swagger.json'
    task :c_sharp do
      build_client 'csharp'
    end

    desc 'Build the Android API client given the swagger definition in doc/swagger/swagger.json'
    task :android do
      build_client 'android'
    end

    desc 'Build the Javascript API client given the swagger definition in doc/swagger/swagger.json'
    task :javascript do
      #todo
    end

    desc 'Build all the API clients'
    task :all => [:ruby, :java, :python, :python_3, :php, :perl, :objective_c, :c_sharp, :android, :javascript]

    task :default => [:all]

  end
end
