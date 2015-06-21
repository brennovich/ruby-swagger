require 'active_support/concern'

module Grape
  module DSL
    module Configuration
      extend ActiveSupport::Concern

      module ClassMethods

        def api_desc(description, options = {}, &block)
          default_api_options!(options)
          block.call if block_given?
          desc description, @api_options
        end

        def headers(headers_value)
          raise ArgumentError.new("Grape::headers - unrecognized value #{headers_value} - allowed: Hash") unless headers_value.is_a?(Hash)

          @api_options[:headers] = headers_value
        end

        def deprecated(deprecation_value)
          raise ArgumentError.new("Grape::deprecated - unrecognized value #{deprecation_value} - allowed: true|false") unless deprecation_value == true || deprecation_value == false

          @api_options[:deprecated] = deprecation_value
        end

        def hidden(hidden_value)
          raise ArgumentError.new("Grape::hidden - unrecognized value #{hidden_value} - allowed: true|false") unless hidden_value == true || hidden_value == false

          @api_options[:hidden] = hidden_value
        end

        def scopes(scopes_value)
          return if scopes_value.nil?

          if scopes_value.is_a?(Array)
            scopes_value.each do |scope|
              raise ArgumentError.new("Grape::scopes - unrecognized scope #{scope_value}") unless scope.is_a?(String)
            end

            @api_options[:scopes] = scopes_value
          elsif scopes_value.is_a?(String)
            @api_options[:scopes] = [scopes_value]
          else
            raise ArgumentError.new("Grape::scopes - unrecognized value #{scopes_value} - scopes can either be a string or an array of strings")
          end
        end

        def tags(new_tags)
          raise ArgumentError.new("Grape::tags - unrecognized value #{new_tags} - tags can only be an array of strings or a string") unless new_tags.is_a?(Array) || new_tags.is_a?(String)

          if new_tags.is_a?(String)
            new_tags = [new_tags]
          end

          @api_options[:tags]= new_tags
        end

        def result(new_result)
          @api_options[:result]= new_result
        end

        def result_root(new_root)
          raise ArgumentError.new("Grape::result_root - unrecognized value #{new_root} - result root must be a string") unless new_root.is_a?(String)
          @api_options[:result_root]= new_root
        end

        def errors(errors_value)
          raise ArgumentError.new("Grape::errors - unrecognized value #{errors_value} - errors root must be a hash of errors") unless errors_value.is_a?(Hash)
          @api_options[:errors]= errors_value
        end

        @@headers = {}
        def default_headers(new_value)
          @@headers = new_value
        end

        @@deprecated = false
        def default_deprecated(new_value)
          @@deprecated = new_value
        end

        @@hidden = false
        def default_hidden(new_value)
          @@hidden = new_value
        end

        @@scopes = nil
        def default_scopes(new_value)
          @@scopes = new_value
        end

        @@tags = []
        def default_tags(new_value)
          @@tags = new_value
        end

        @@result = nil
        def default_result(new_value)
          @@result = new_value
        end

        @@result_root = nil
        def default_result_root(new_value)
          @@result_root = new_value
        end

        @@errors = nil
        def default_errors(new_value)
          @@errors = new_value
        end

        def default_api_options!(options)
          @api_options = {
              headers: @@headers,
              deprecated: @@deprecated,
              hidden: @@hidden,
              scopes: @@scopes,
              tags: @@tags,
              result: @@result,
              result_root: @@result_root,
              errors: @@errors
          }.merge(options)
          @description = ''
        end
      end
    end
  end
end
