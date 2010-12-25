require 'rake/testtask'
lib_dir = File.expand_path('lib')
test_dir = File.expand_path('test')

# Rakefile
desc "Cross the bridge."
task :cross_bridge => [:build_bridge] do
  puts "I'm crossing the bridge."
end

desc "Build the bridge."
task :build_bridge do
  puts 'Bridge construction is complete.'
end

task :default => [:cross_bridge]

Rake::TestTask.new('test-file') do |t|
  t.test_files = ['test/tc_datafile.rb',
                  'test/tc_datafilewriter.rb',
                  'test/tc_datafilereader.rb']
  t.warning = true
end

Rake::TestTask.new('test-console') do |t|
  t.test_files = ['test/tc_console.rb',
                  'test/tc_prettyprinter.rb']
  t.warning = true
end

task 'test' => ['test-file', 'test-console']
