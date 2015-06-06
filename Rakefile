require 'rspec/core/rake_task'

task :build do
  system "gem build ruby-swagger.gemspec"
end

task :default => [:spec, :build]