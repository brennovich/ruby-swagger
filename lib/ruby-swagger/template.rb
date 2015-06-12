require 'ruby-swagger/data/document'

module Swagger
  class Template

    def self.generate
      swagger_doc = Swagger::Data::Document.new

      if defined?(Rails)
        swagger_doc.info.title = Rails.application.class.name.split('::').first.underscore
        swagger_doc.info.description = Rails.application.class.name.split('::').first.underscore
      end

      swagger_doc.host = 'localhost:80'
      swagger_doc.basePath = '/api/v1'

      swagger_doc.schemes = ['https', 'http']
      swagger_doc.produces = ['application/json']
      swagger_doc.consumes = ['application/json']

      swagger_doc.info.contact = Swagger::Data::Contact.new
      swagger_doc.info.license = Swagger::Data::License.new
      swagger_doc.info.termsOfService = 'https://localhost/tos.html'

      swagger_doc
    end

  end
end