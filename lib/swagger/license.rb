require 'swagger/data/url'

module Swagger
  class License  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#license-object

    DEFAULT_NAME = 'Apache 2.0'
    DEFAULT_URL = 'http://www.apache.org/licenses/LICENSE-2.0.html'

    attr_reader :name

    def initialize
      @name = DEFAULT_NAME
      @url = Swagger::Data::Url.new(DEFAULT_URL)
    end

    def self.parse(license)
      raise (ArgumentError.new("license object is nil [#{Swagger::License._desc}]")) unless license

      l = Swagger::License.new
      l.name = license['name']
      l.url = license['url']

      l
    end

    def name=(new_name)
      raise (ArgumentError.new("license name is invalid [#{Swagger::License.name_desc}]")) if new_name.nil? || new_name.empty?
      @name = new_name
    end

    def url=(url)
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

    def to_json
      to_swagger.to_json
    end

    def to_yaml
      to_swagger.to_yaml
    end

    def to_swagger
      {
          name: @name,
          url: @url.to_swagger
      }
    end

    def self._desc
      'Swagger::Licence - License information for the exposed API. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#license-object'
    end

    def self.name_desc
      'Swagger::Licence#name - Required. The license name used for the API. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-3'
    end

    def self.url_desc
      'Swagger::Licence#url - A URL to the license used for the API. MUST be in the format of a URL. See https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#fixed-fields-3'
    end

    private

    def validate_url!
      raise (ArgumentError.new("contact url is invalid [#{Swagger::License.url_desc}]")) unless @url.valid?
    end

  end
end