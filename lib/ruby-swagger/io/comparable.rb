module Swagger::IO
  class Comparable

    def self.copy_description_old_definition(definition, old_definition)
      return if definition.nil? || old_definition.nil? || definition.class != old_definition.class

      case definition
        when Hash

          definition.keys.each do |key|
            old_v = definition[key]

            if (key == 'description' || key == 'summary') && old_definition[key]
              definition[key] = old_definition[key]
            end

            if old_v.is_a?(Hash) || old_v.is_a?(Array)
              copy_description_old_definition(definition[key], old_definition[key])
            end
          end
        when Array
          definition.each_with_index do |item, index|
            copy_description_old_definition(definition[index], old_definition[index])
          end
      end
    end

  end

end
