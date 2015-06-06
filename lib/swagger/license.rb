module Swagger
  class License  #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#license-object

    DEFAULT_NAME = 'Apache 2.0'
    DEFAULT_URL = 'http://www.apache.org/licenses/LICENSE-2.0.html'

    attr_accessor :name

    def initialize
      @name = DEFAULT_NAME
      @url = Swagger::Data::URL.new(DEFAULT_URL)
    end

    def url=(url)
      @url = Swagger::Data::Url.new(url)
      validate_url!
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

  end
end