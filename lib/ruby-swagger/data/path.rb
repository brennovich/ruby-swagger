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

    def self.get=(new_get)
      raise (ArgumentError.new("Swagger::Data::Path#get= - get is nil")) unless new_get
      raise (ArgumentError.new("Swagger::Data::Path#get= - get is not a Swagger::Operations::Operation")) unless new_get.is_a?(Swagger::Operations::Operation)
      @get = new_get
    end

    def self.put=(new_put)
      raise (ArgumentError.new("Swagger::Data::Path#put= - put is nil")) unless new_put
      raise (ArgumentError.new("Swagger::Data::Path#put= - put is not a Swagger::Operations::Operation")) unless new_put.is_a?(Swagger::Operations::Operation)
      @put = new_put
    end

    def self.post=(new_post)
      raise (ArgumentError.new("Swagger::Data::Path#post= - post is nil")) unless new_post
      raise (ArgumentError.new("Swagger::Data::Path#post= - post is not a Swagger::Operations::Operation")) unless new_post.is_a?(Swagger::Operations::Operation)
      @post= new_post
    end

    def self.delete=(new_delete)
      raise (ArgumentError.new("Swagger::Data::Path#delete= - is nil")) unless new_delete
      raise (ArgumentError.new("Swagger::Data::Path#delete - delete is not a Swagger::Operations::Operation")) unless new_delete.is_a?(Swagger::Operations::Operation)
      @delete= new_delete
    end

    def self.options=(new_options)
      raise (ArgumentError.new("Swagger::Data::Path#options= - options is nil")) unless new_options
      raise (ArgumentError.new("Swagger::Data::Path#options= - options is not a Swagger::Operations::Operation")) unless new_options.is_a?(Swagger::Operations::Operation)
      @options= new_options
    end

    def self.head=(new_head)
      raise (ArgumentError.new("Swagger::Data::Path#head= - head is nil")) unless new_head
      raise (ArgumentError.new("Swagger::Data::Path#head= - is not a Swagger::Operations::Operation")) unless new_head.is_a?(Swagger::Operations::Operation)
      @head= new_head
    end

    def self.patch=(new_patch)
      raise (ArgumentError.new("Swagger::Data::Path#patch= - is nil")) unless new_patch
      raise (ArgumentError.new("Swagger::Data::Path#patch= - patch is not a Swagger::Operations::Operation")) unless new_patch.is_a?(Swagger::Operations::Operation)
      @patch= new_patch
    end

    def self.parameters=(new_parameters)
      raise (ArgumentError.new("Swagger::Data::Path#parameters= - parameters is nil")) unless new_parameters
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
      raise (ArgumentError.new("Swagger::Data::Path#ref= - $ref is nil")) unless new_ref
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
