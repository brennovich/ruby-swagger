require 'ruby-swagger/object'
require 'ruby-swagger/data/items'

module Swagger::Data
  class Header < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#header-object
    attr_swagger :description, :type, :format, :items,
                 :collectionFormat, :default, :maximum,
                 :exclusiveMaximum, :minimum, :exclusiveMinimum,
                 :maxLength, :minLength, :pattern, :maxItems,
                 :minItems, :uniqueItems, :enum, :multipleOf

    def self.parse(header)
      return nil unless header

      Swagger::Data::Header.new.bulk_set(header)
    end

    def type=(new_type)
      raise ArgumentError.new('Swagger::Data::Header#type called with nil') if new_type.nil?
      @type = new_type
    end

    def items=(new_items)
      raise ArgumentError.new('Swagger::Data::Header#items= items is nil') if new_items.nil? && @type == 'array'
      if !new_items.nil? && !new_items.is_a?(Swagger::Data::Items)
        new_items = Swagger::Data::Items.parse(new_items)
      end

      @items = new_items
    end
  end
end
