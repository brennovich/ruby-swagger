require 'ruby-swagger/data/document'

require 'ruby-swagger/railtie' if defined?(Rails)

if defined?(Grape)
  require 'ruby-swagger/grape/grape'
end