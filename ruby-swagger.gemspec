Gem::Specification.new do |s|
  s.name      = 'ruby-swagger'
  s.version   = `cat #{File.dirname(__FILE__)}/VERSION`
  s.authors   = ['Luca Bonmassar']
  s.email     = ['luca@gild.com']
  s.homepage  = 'https://github.com/gild/ruby-swagger'
  s.summary   = 'A ruby DSL to read/write Swagger API documents'
  s.description = 'A super simple library to read or create (Swagger)[http://swagger.io/] API documents.
This is the engine used in other gems to translate API definitions (grape, rails) into Swagger definitions.'
  s.files     = `git ls-files | grep lib`.split("\n")
  s.license   = 'MIT'

  s.add_dependency 'addressable'

  s.add_development_dependency 'grape'
  s.add_development_dependency 'grape-entity', '~> 0.5'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake', '>= 0.9.2'
  s.add_development_dependency 'roar'
  s.add_development_dependency 'rspec'
end
