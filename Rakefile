require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'opal/rspec/rake_task'
require 'akin/opal'

RSpec::Core::RakeTask.new('rspec:ruby') do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

Opal::RSpec::RakeTask.new('rspec:opal') do |_server, task|
  task.pattern      = 'spec/**/*_spec.rb'
end

task default: ['rspec:ruby', 'rspec:opal']
