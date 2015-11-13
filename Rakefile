require "rubygems"

require "bundler"
Bundler.setup
Bundler::GemHelper.install_tasks

require "inch/rake"
Inch::Rake::Suggest.new(:inch)

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new(:rubocop)

task :default => [:spec, :rubocop, :inch]
