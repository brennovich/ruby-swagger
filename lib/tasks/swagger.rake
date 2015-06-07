require 'ruby-swagger/io/file_system'

namespace :swagger do

  namespace :grape do
    desc 'Generate a swagger meta documentation from Grape API definition'
    task :generate_doc do
      puts "Exporting from Grape"

      # Get path data from Grape

      # Define a 'standard' swagger document
      swagger_doc = Swagger::Document.new
      swagger_doc.info.title = Rails.application.class.name.split('::').first.underscore
      swagger_doc.info.description = Rails.application.class.name.split('::').first.underscore
      swagger_doc.info.contact = Swagger::Contact.new
      swagger_doc.info.license = Swagger::License.new

      #Lot of TODO here

      Swagger::IO::FileSystem.new(swagger_doc).write!
      puts "You should check your swagger meta documentation under #{Swagger::IO::FileSystem.default_path}"
    end
  end

end
