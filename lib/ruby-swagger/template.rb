require 'ruby-swagger/document'
require 'ruby-swagger/contact'
require 'ruby-swagger/info'
require 'ruby-swagger/license'

module Swagger
  class Template

    def self.generate
      swagger_doc = Swagger::Document.new

      if defined?(Rails)
        swagger_doc.info.title = Rails.application.class.name.split('::').first.underscore
        swagger_doc.info.description = Rails.application.class.name.split('::').first.underscore
      end

      swagger_doc.info.contact = Swagger::Contact.new
      swagger_doc.info.license = Swagger::License.new

      swagger_doc
    end

  end
end