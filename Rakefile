require 'rspec/core/rake_task'

desc 'Build the library'
task :build do
  system "gem build ruby-swagger.gemspec"
end

task :default => [:spec, :build]

import "./lib/tasks/swagger.rake"