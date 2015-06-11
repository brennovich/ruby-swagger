require 'ruby-swagger/object'
require 'ruby-swagger/data/items'
require 'ruby-swagger/data/schema'

module Swagger::Data
  class Parameter < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#itemsObject

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

  end
end