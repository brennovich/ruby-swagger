require 'active_support/concern'

module Grape
  module DSL
    module InsideRoute
      def api_present(*args)
        args_list = args || []
        options = {}

        # Initialize the options hash - either by assigning to the current options for the method or with a new one
        if args_list.count == 2

          if args_list.last.is_a?(Hash)
            options = args_list.last
          else
            raise ArgumentError.new "The expected second argument for api_present is a Hash, but I got a #{args_list.last.class}"
          end

        elsif args_list.count == 1

          # Initialize the option list
          args_list << options

        elsif args_list.count > 2 || args_list.count == 0
          raise ArgumentError.new "Invalid number of arguments - got #{args_list.count}. expected 1 or 2 parameters"
        end

        # Setting the grape :with
        if route.route_response.present? && route.route_response[:entity].present? && !options[:with].present? && route.route_response[:entity].is_a?(Class)
          options[:with] = route.route_response[:entity]
        end

        # Setting the grape :root
        if route.route_response.present? && route.route_response[:root].present? && !options[:root].present? && route.route_response[:root].is_a?(String)
          options[:root] = route.route_response[:root]
        end

        # Setting the :current_user extension
        options[:current_user] = current_user if defined?(current_user)

        present *args_list
      end
    end
  end
end
