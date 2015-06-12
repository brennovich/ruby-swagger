require 'ruby-swagger/object'
require 'ruby-swagger/data/contact'
require 'ruby-swagger/data/license'

module Swagger::Data
  class Info < Swagger::Object  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#info-object

    DEFAULT_TITLE = 'My uber-duper API'
    DEFAULT_DESCRIPTION = 'My uber-duper API description'
    DEFAULT_VERSION = '0.1'

    attr_swagger :title, :description, :termsOfService, :contact, :license, :version

    def initialize
      @title = DEFAULT_TITLE
      @description = DEFAULT_DESCRIPTION
      @version = DEFAULT_VERSION
    end

    def self.parse(info)
      raise (ArgumentError.new("Swagger::Data::Info#parse - info object is nil")) unless info

      Swagger::Data::Info.new.bulk_set(info)
    end

    def title=(new_title)
      raise (ArgumentError.new("Swagger::Data::Info#title= - title is invalid")) if new_title.nil? || new_title.empty?
      @title = new_title
    end

    def contact=(new_contact)
      return nil unless new_contact

      if(!new_contact.is_a?(Swagger::Data::Contact))
        new_contact = Swagger::Data::Contact.parse(new_contact)
      end

      @contact = new_contact
    end

    def license=(new_license)
      return nil unless new_license

      if(!new_license.is_a?(Swagger::Data::License))
        new_license = Swagger::Data::License.parse(new_license)
      end

      @license = new_license
    end

    def valid?
      @license.valid? && @contact.valid?
    end

  end
end