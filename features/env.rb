REAL_PIK_HOME = File.join(ENV['HOME'], '.pik')
FAKE_PIK_HOME = 'c:/temp/.pik'

ENV['HOME'] = "C:\\temp"

Before do
  FileUtils.mkdir_p FAKE_PIK_HOME
  FileUtils.cp File.join(REAL_PIK_HOME, 'config.yml'), FAKE_PIK_HOME
end
