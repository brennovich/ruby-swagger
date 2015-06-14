require 'ruby-swagger/object'
require 'ruby-swagger/data/items'
require 'ruby-swagger/data/schema'

module Swagger::Data
  class Parameter < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#parameter-object

    attr_swagger :name, :in, :description, :required, :schema,
                 :type, :format, :allowEmptyValue, :items,
                 :collectionFormat, :default, :maximum,
                 :exclusiveMaximum, :minimum, :exclusiveMinimum,
                 :maxLength, :minLength, :pattern, :maxItems,
                 :minItems, :uniqueItems, :enum, :multipleOf

    def self.parse(new_parameter)
      return nil unless new_parameter

      p = Swagger::Data::Parameter.new
      %w(name in description required).each do |field|
        p.send("#{field}=", new_parameter[field])
      end

      if p.in == 'body'
        p.schema = Swagger::Data::Schema.parse(new_parameter['schema'])
      else
        %w(type format allowEmptyValue collectionFormat default maximum exclusiveMaximum minimum exclusiveMinimum maxLength minLength pattern maxItems minItems uniqueItems enum multipleOf).each do |field|
          p.send("#{field}=", new_parameter[field])
        end
        p.items = Swagger::Data::Items.parse(new_parameter['items'])
      end

      p
    end

    def name=(new_name)
      raise ArgumentError.new('Swagger::Data::Parameter#name called with nil') if new_name.nil?
      @name = new_name
    end

    def in=(new_in)
      raise ArgumentError.new('Swagger::Data::Parameter#in= called with nil') if new_in.nil?
      raise ArgumentError.new("Swagger::Data::Parameter#in= called with invalid value #{new_in}") unless %w(query header path formData body).include?(new_in)

      @in = new_in
    end

    def items=(new_items)
      raise ArgumentError.new("Swagger::Data::Parameter#items= items is nil") if new_items.nil? && @type == 'array'
      if !new_items.nil? && !new_items.is_a?(Swagger::Data::Items)
        new_items = Swagger::Data::Items.parse(new_items)
      end

      @items = new_items
    end

    def self.from_grape(grape_parameter)
      return nil unless grape_parameter && grape_parameter.last.is_a?(Hash)
      parameter = Swagger::Data::Parameter.new
      parameter.name= grape_parameter.first
      parameter.in= 'formData'

      if grape_parameter.last[:required] && grape_parameter.last[:required] == true
        parameter.required = true
      end

      parameter.description = grape_parameter.last[:desc]
      grape_type_to_swagger(parameter, grape_parameter.last[:type] || 'string')

      if parameter.type == 'array'
        items = Swagger::Data::Items.new
        items.type = 'string'
        parameter.items = items
      end

      parameter.type.nil? ? nil : parameter
    rescue => e
      puts "error processing parameter #{grape_parameter} [#{e}]"
      raise e
    end

    private

    def self.grape_type_to_swagger(parameter, type)
      parameter.type = case type.downcase
        when 'string'
          'string'
        when 'integer'
          'integer'
        when 'array'
          'array'
        when 'hash'
          nil #no ashes
        when 'virtus::attribute::boolean'
          'boolean'
        when 'symbol'
          'string'
        when 'float'
          parameter.format= 'float'
          'number'
        when 'rack::multipart::uploadedfile'
          'file'
        when 'date'
          parameter.format = 'date'
          'string'
        when 'datetime'
          parameter.format = 'date-time'
          'string'
        else
          raise "Don't know how to convert they grape type #{type}"
      end
    end

  end
end