require 'rake/testtask'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = ['lib/**/*.rb', 'test/**/*.rb']
  task.fail_on_error = false
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
end
desc "Run tests"

task default: %w[lint test]
