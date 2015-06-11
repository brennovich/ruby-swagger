require 'ruby-swagger/data/url'
require 'ruby-swagger/object'

module Swagger::Data
  class License < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#license-object

    DEFAULT_NAME = 'Apache 2.0'
    DEFAULT_URL = 'http://www.apache.org/licenses/LICENSE-2.0.html'

    attr_swagger :name, :url

    def initialize
      @name = DEFAULT_NAME
      @url = Swagger::Data::Url.new(DEFAULT_URL)
    end

    def self.parse(license)
      raise (ArgumentError.new("Swagger::Data::License - license object is nil")) unless license

      Swagger::Data::License.new.bulk_set(license)
    end

    def name=(new_name)
      raise (ArgumentError.new("Swagger::Data::License - license name is invalid ")) if new_name.nil? || new_name.empty?
      @name = new_name
    end

    def url=(url)
      return nil unless url

      @url = Swagger::Data::Url.new(url)
      validate_url!
      @url
    end

    def url
      @url.url
    end

    def valid?
      @url.valid?
    end

    private

    def validate_url!
      raise (ArgumentError.new("Swagger::Data::License - contact url is invalid")) unless @url.valid?
    end

  end
end