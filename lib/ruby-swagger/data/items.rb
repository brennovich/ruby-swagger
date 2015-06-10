require 'ruby-swagger/object'

module Swagger::Data
  class Items < Swagger::Object # https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#itemsObject

    attr_swagger :type, :format, :items, :collectionFormat, :default,
                 :maximum, :exclusiveMaximum, :minimum, :exclusiveMinimum,
                 :maxLength, :minLength, :pattern, :maxItems,
                 :minItems, :uniqueItems, :enum, :multipleOf

    def initialize
      @type = "string"  #we default to an array of strings
    end

    def self.parse(items)
      return nil if items.nil?

      Swagger::Data::Items.new.bulk_set(items)
    end

    def type=(new_type)
      raise ArgumentError.new("Swagger::Data::Items#type= - type is nil") unless new_type
      raise ArgumentError.new("Swagger::Data::Items#type= - type #{new_type} is invalid") unless %w(string number integer boolean array).include?(new_type)

      @type = new_type
    end

    def items=(new_items)
      raise ArgumentError.new("Swagger::Data::Items#items= - is nil") if new_items.nil? && @type == 'array'

      if !new_items.nil? && !new_items.is_a?(Swagger::Data::Items)
        new_items = Swagger::Data::Items.parse(new_items)
      end

      @items = new_items
    end

    def collectionFormat=(new_collection_format)
      return nil unless new_collection_format
      raise ArgumentError.new("collectionFormat #{new_collection_format} is invalid [#{Swagger::Data::Items.collectionFormat_desc}]") unless %w(csv ssv tsv pipes).include?(new_collection_format)
      @collectionFormat = new_collection_format
    end

  end
end