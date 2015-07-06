module Swagger::Grape
  class Type

    def initialize(type)
      @type = type
    end

    def to_swagger
      {"moo"=>"miao"}
    end


  end
end