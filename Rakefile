# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'navvy/tasks'

task :statsetup do
  require 'code_statistics'
  ::STATS_DIRECTORIES << %w(Cucumber\ features features) if File.exist?('features')
  ::CodeStatistics::TEST_TYPES << "Cucumber features" if File.exist?('features')
end
task :stats => "statsetup"
