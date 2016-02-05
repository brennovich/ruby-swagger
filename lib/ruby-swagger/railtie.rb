module Swagger
  class Railtie < Rails::Railtie
    rake_tasks do
      load "#{File.dirname(__FILE__)}/../tasks/swagger.rake"
    end
  end
end
