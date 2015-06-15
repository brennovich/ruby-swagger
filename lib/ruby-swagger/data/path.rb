require 'ruby-swagger/object'
require 'ruby-swagger/data/operation'
require 'ruby-swagger/data/parameter'
require 'ruby-swagger/data/reference'

module Swagger::Data
  class Path < Swagger::Object #https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#path-item-object

    attr_swagger :get, :put, :post, :delete, :options, :head, :patch, :parameters #and $ref
    @ref = nil

    def self.parse(path)
      raise (ArgumentError.new("Swagger::Data::Path - path is nil")) unless path

      res = Swagger::Data::Path.new.bulk_set(path)
      res.ref= path['$ref'] if path['$ref']
      res
    end

    def get=(new_get)
      return nil unless new_get
      unless new_get.is_a?(Swagger::Data::Operation)
        new_get = Swagger::Data::Operation.parse(new_get)
      end

      @get = new_get
    end

    def self.put=(new_put)
      return nil unless new_put
      unless new_put.is_a?(Swagger::Data::Operation)
        new_put = Swagger::Data::Operation.parse(new_put)
      end
      @put = new_put
    end

    def post=(new_post)
      return nil unless new_post
      unless new_post.is_a?(Swagger::Data::Operation)
        new_post = Swagger::Data::Operation.parse(new_post)
      end
      @post= new_post
    end

    def delete=(new_delete)
      return nil unless new_delete
      unless new_delete.is_a?(Swagger::Data::Operation)
        new_delete = Swagger::Data::Operation.parse(new_delete)
      end
      @delete= new_delete
    end

    def options=(new_options)
      return nil unless new_options
      unless new_options.is_a?(Swagger::Data::Operation)
        new_options = Swagger::Data::Operation.parse(new_options)
      end
      @options= new_options
    end

    def head=(new_head)
      return nil unless new_head
      unless new_head.is_a?(Swagger::Data::Operation)
        new_head = Swagger::Data::Operation.parse(new_head)
      end

      @head= new_head
    end

    def patch=(new_patch)
      return nil unless new_patch
      unless new_patch.is_a?(Swagger::Data::Operation)
        new_patch = Swagger::Data::Operation.parse(new_patch)
      end
      @patch= new_patch
    end

    def parameters=(new_parameters)
      return nil unless new_parameters
      raise (ArgumentError.new("Swagger::Data::Path#parameters= - parameters is not an array")) unless new_parameters.is_a?(Array)

      @parameters ||= []

      path['parameters'].each do |parameter|
        new_param = if parameter['$ref']
                      #it's a reference object
                      Swagger::Data::Reference.parse(parameter)
                    else
                      #it's a parameter object
                      Swagger::Data::Parameter.parse(parameter)
                    end

        parameters.push(new_param)
      end

      res.parameters=parameters

      path['parameters'] if path['parameters']


      @parameters= new_parameters
    end

    def ref=(new_ref)
      return nil unless new_ref
      raise (ArgumentError.new("Swagger::Data::Path#ref= - $ref is not a string")) unless new_ref.is_a?(String)

      @ref = new_ref
    end

    def ref
      @ref
    end

    def as_swagger
      res = super
      res['$ref'] = @ref if @ref
      res
    end
  end
end
