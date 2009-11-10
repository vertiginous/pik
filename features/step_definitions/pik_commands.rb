Given /^I have.+added "(.+)"/ do |version|
  @version = version
  @version_reg = Regexp.new(Regexp.escape(version), Regexp::IGNORECASE)
  @config_file = TEST_PIK_HOME + 'config.yml'
  @original_config = YAML.load(File.read(@config_file))
  @ver = @original_config.keys.grep(@version_reg){|k| @original_config[k] }
  @ver.size.should eql(1)
end

Given /^I only have the rake gem installed to version 1\.9\.1\.$/ do
  x = `pik 191 & gem list`.split("\n").map{|gem_| gem_.split(' ') }
  x.map! do |name, version|
    unless name == 'rake'
      `pik 191 & gem unin #{name} -x -I`
      name
    end
  end
  x.should_not include('rake')
end

Given /^I am currently using it\.$/ do
  unless `ruby -v` =~ @version_reg
    k,v = `pik switch #{@version} & path`.split('=')
    ENV[k]=v
  end
  `ruby -v`.should match(@version_reg)
end

Given /^I am currently using "(.+)"$/ do |version|
  Given "I have added \"#{version}\""
  Given "I am currently using it."
end

Given /^I have a directory "(.+)"/ do |directory|
  @dir = directory
  Pathname(@dir).directory?.should be_true
end

Given /^it contains a config\.yml/ do
  config = Pathname(@dir) + 'config.yml'
  config.should exist
end

Given /^I have no \.pik directory/ do
  FileUtils.rm_rf TEST_PIK_HOME
  TEST_PIK_HOME.should_not exist
end

Given /^I have an empty config\.yml/ do
  File.open(TEST_PIK_HOME + 'config.yml','w'){|f| }
end

Given /^there is no ruby version in the path$/ do
  ENV['PATH'] = SearchPath.new(REAL_PATH).remove(Which::Ruby.find).join
end

Given /^I have not installed pik to (.+)$/ do |path|
  FileUtils.rm_rf path if File.exist? path
  FileUtils.mkdir_p path
  Dir[path + "\\pik.bat"].should be_empty
end

Given /^"(.*)" is in the system path$/ do |arg1|
  ENV['PATH'] = [arg1, ENV['PATH']].join(';')
end

When /^I run "pik_install (.+)"$/ do |args|
  %x[ruby bin/pik_install #{args} > #{PIK_LOG} 2>&1 ]
end

When /^I run "pik (.+?)" and "pik (.+)",$/ do |args1, args2|
  %x[tools\\pik.bat #{args1} > #{PIK_LOG} 2>&1 & tools\\pik.bat #{args2} >> #{PIK_LOG} 2>&1]
end

When /^I run "pik (.+?)"$/ do |args|
  %x[tools\\pik.bat #{args} > #{PIK_LOG} 2>&1 ]
end

When /^I run "pik (.*)" and check the environment$/ do |args|
  system("echo > #{PIK_LOG}")
  cmds = ["tools\\pik.bat #{args}", "PATH", "SET G"].map{|cmd| "#{cmd } >> #{PIK_LOG} 2>&1"}
  %x[#{cmds.join(' & ')}]
end

# When /^I run "(.*)"$/ do |args|
#   @cmds ||= []
# end

And /^then I run "(.*)"$/ do |args|
  %x[#{args} >> #{PIK_LOG} 2>&1 ]
end

Then /^I should see "(.*)"$/ do |data|
  stdout = File.read(PIK_LOG)
  stdout.should match(Regexp.new(Regexp.escape(data)))
end


Then /^I should see the Pik::VERSION$/ do
  stdout = File.read(PIK_LOG)
  stdout.should match(Regexp.new(Regexp.escape(Pik::VERSION)))
end

Then /^I should not see "([^\"]*)"$/ do |arg1|
  stdout = File.read(PIK_LOG)
  stdout.should_not match(Regexp.new(Regexp.escape(arg1)))
end

Then /^I should find "(.*)"$/ do |regexp|
  stdout = File.read(PIK_LOG)
  stdout.should match(Regexp.new(regexp))
end


Then /^I should find "(.*)" (\d+) times$/ do |regexp, count|
  stdout = File.read(PIK_LOG)
  items = stdout.scan(Regexp.new(regexp))
  items.size.should eql(count.to_i)
end

Then /^the path should point to it\.$/ do
  path  = @ver[0][:path]
  path = path.to_s.gsub('/','\\')
  Then "the path should point to \"#{path}\""
end

Then /^the path should point to "(.+)"$/ do |path|
  stdout = File.read(PIK_LOG)
  stdout.should match( Regexp.new(Regexp.escape(path)) )
end

Then /^the "([^\"]*)" variable will include "([^\"]*)"\.$/ do |var, string|
  stdout = File.read(PIK_LOG)
  stdout.should match( Regexp.new("#{var}=.+#{Regexp.escape(string)}") )
end


Then /^I should see each version.s path listed$/ do
  stdout = File.read(PIK_LOG)
  config_file = TEST_PIK_HOME + 'config.yml'
  config = YAML.load(File.read(config_file))
  config.each{|k,v| 
    path = Regexp.new(Regexp.escape(v[:path].to_s.gsub('/','\\')))
    stdout.should match(path)
  }
end

Then /^I should see each version listed\.$/ do
  stdout = File.read(PIK_LOG)
  config_file = TEST_PIK_HOME + 'config.yml'
  config = YAML.load(File.read(config_file))
  config.each{|k,v| 
    version = Regexp.new(Regexp.escape(k.split(': ')[1..-1].join(': ')))
    stdout.should match(version)
  }  
end

Then /^the GEM_HOME might get set\.$/ do
  gem_home  = @ver[0][:gem_home]
  if gem_home
    gem_home = gem_home.to_s.gsub('/','\\')
    reg_gem_home = Regexp.new(Regexp.escape(gem_home), Regexp::IGNORECASE)
    stdout = File.read(PIK_LOG)
    stdout.should match(reg_gem_home)
  end
end

Then /^the directory should be deleted$/ do
  Pathname(TEST_PIK_HOME).should_not exist
end

Then /^nothing should be added to the config file\.$/ do
  @current_config = YAML.load(File.read(@config_file))
  @current_config.size.should eql(@original_config.size)
end

Then /^the version should be removed\.$/ do
  @current_config = YAML.load(File.read(@config_file))
  @current_config.size.should eql(@original_config.size - 1)
end

Then /^a gem_home option should be added to the config\.$/ do
  @ver[0][:gem_home].should be_nil
  @current_config = YAML.load(File.read(@config_file))
  @ver = @current_config.keys.grep(@version_reg){|k| @current_config[k] }
  @ver[0][:gem_home].should_not be_nil
end