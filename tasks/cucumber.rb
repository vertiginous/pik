require 'cucumber'
require 'cucumber/rake/task'

@dir = Pathname(File.dirname(__FILE__)) 
@test_versions = {
  'JRuby'     => ['1.5.1'],
  'IronRuby'  => ['0.9.2'],
  'Ruby'      => [
    '1.9.1-p378-1',
    '1.8.6-p398-2',
    '1.8.7-p249-1'
  ]
}

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features  -f html -o ../pik_cucumber.html -f progress"
end

desc "generate a guid"
task :guid do
  puts
  puts UUID.new.generate.upcase
end
