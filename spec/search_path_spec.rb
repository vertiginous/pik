require 'lib/pik/search_path'
require 'pathname'
require 'lib/pik/core_ext/pathname'

describe SearchPath do

	before :each do
		path =  'C:\Program Files\Common Files\Shoes\0.r1134\..;'
		path <<	'C:\bin;'
		path <<	'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727;'
		path <<	'C:\Program Files\Common Files\Shoes\0.r395\..;'
		path <<	'C:\windows\system32;'
		path <<	'C:\windows\system;'
		path <<	'C:\Program Files\Subversion\bin;'
		path <<	'C:\Program Files\MySQL\MySQL Server 5.0\bin;'
		path <<	'C:\Program Files\Common Files\Lenovo;'
		path <<	'C:\Program Files\QuickTime\QTSystem\;'
		path <<	'C:\Program Files\Git\cmd;'
		path <<	'C:\Program Files\jEdit;'
		path <<	'C:\WINDOWS\system32\WindowsPowerShell\v1.0\;'
		path <<	'C:\ruby\186-mswin32\bin;'
		path <<	'C:\Program Files\Putty'
		@path = SearchPath.new(path)
	end
	
	describe '#replace' do

		it "should replace one element with another using a string" do
			path =	'C:/ruby/191/bin'
			new_path =  'C:\Program Files\Common Files\Shoes\0.r1134\..;'
			new_path <<	'C:\bin;'
			new_path <<	'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727;'
			new_path <<	'C:\Program Files\Common Files\Shoes\0.r395\..;'
			new_path <<	'C:\windows\system32;'
			new_path <<	'C:\windows\system;'
			new_path <<	'C:\Program Files\Subversion\bin;'
			new_path <<	'C:\Program Files\MySQL\MySQL Server 5.0\bin;'
			new_path <<	'C:\Program Files\Common Files\Lenovo;'
			new_path <<	'C:\Program Files\QuickTime\QTSystem\;'
			new_path <<	'C:\Program Files\Git\cmd;'
			new_path <<	'C:\Program Files\jEdit;'
			new_path <<	'C:\WINDOWS\system32\WindowsPowerShell\v1.0\;'
			new_path <<	'C:\ruby\191\bin;'
			new_path <<	'C:\Program Files\Putty'
			updated_path = @path.replace('C:/ruby/186-mswin32/bin', path).join
			updated_path.should == new_path
		end
	end

	describe '#add' do
		it "should add an element to the beginning" do
			path =	'C:/ruby/191/bin'
			new_path =  'C:\ruby\191\bin;'
			new_path <<	'C:\Program Files\Common Files\Shoes\0.r1134\..;'
			new_path <<	'C:\bin;'
			new_path <<	'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727;'
			new_path <<	'C:\Program Files\Common Files\Shoes\0.r395\..;'
			new_path <<	'C:\windows\system32;'
			new_path <<	'C:\windows\system;'
			new_path <<	'C:\Program Files\Subversion\bin;'
			new_path <<	'C:\Program Files\MySQL\MySQL Server 5.0\bin;'
			new_path <<	'C:\Program Files\Common Files\Lenovo;'
			new_path <<	'C:\Program Files\QuickTime\QTSystem\;'
			new_path <<	'C:\Program Files\Git\cmd;'
			new_path <<	'C:\Program Files\jEdit;'
			new_path <<	'C:\WINDOWS\system32\WindowsPowerShell\v1.0\;'
			new_path <<	'C:\ruby\186-mswin32\bin;'
			new_path <<	'C:\Program Files\Putty'
			
			@path.add(path)
			@path.join.should == new_path
		end
	end

	describe '#replace_or_add' do

		it "should replace one element with another using a string" do
			path =	'C:/ruby/191/bin'
			new_path =  'C:\Program Files\Common Files\Shoes\0.r1134\..;'
			new_path <<	'C:\bin;'
			new_path <<	'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727;'
			new_path <<	'C:\Program Files\Common Files\Shoes\0.r395\..;'
			new_path <<	'C:\windows\system32;'
			new_path <<	'C:\windows\system;'
			new_path <<	'C:\Program Files\Subversion\bin;'
			new_path <<	'C:\Program Files\MySQL\MySQL Server 5.0\bin;'
			new_path <<	'C:\Program Files\Common Files\Lenovo;'
			new_path <<	'C:\Program Files\QuickTime\QTSystem\;'
			new_path <<	'C:\Program Files\Git\cmd;'
			new_path <<	'C:\Program Files\jEdit;'
			new_path <<	'C:\WINDOWS\system32\WindowsPowerShell\v1.0\;'
			new_path <<	'C:\ruby\191\bin;'
			new_path <<	'C:\Program Files\Putty'
			@path.replace_or_add('C:/ruby/186-mswin32/bin', path)
			@path.join.should == new_path
		end

		it "should add an element to the beginning if it doesn't already exist" do
			path =	'C:/xray/yankee/zebra'
			new_path =  'C:\xray\yankee\zebra;'
			new_path <<	'C:\Program Files\Common Files\Shoes\0.r1134\..;'
			new_path <<	'C:\bin;'
			new_path <<	'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727;'
			new_path <<	'C:\Program Files\Common Files\Shoes\0.r395\..;'
			new_path <<	'C:\windows\system32;'
			new_path <<	'C:\windows\system;'
			new_path <<	'C:\Program Files\Subversion\bin;'
			new_path <<	'C:\Program Files\MySQL\MySQL Server 5.0\bin;'
			new_path <<	'C:\Program Files\Common Files\Lenovo;'
			new_path <<	'C:\Program Files\QuickTime\QTSystem\;'
			new_path <<	'C:\Program Files\Git\cmd;'
			new_path <<	'C:\Program Files\jEdit;'
			new_path <<	'C:\WINDOWS\system32\WindowsPowerShell\v1.0\;'
			new_path <<	'C:\ruby\186-mswin32\bin;'
			new_path <<	'C:\Program Files\Putty'
			
			@path.replace_or_add('C:/xray/yankee/alpha', path)
			@path.join.should == new_path
		end

		describe "find" do
			it "should return the first path where block is not false" do
				path = SearchPath.new(ENV['PATH'])
				dir = path.find{|i| !!Dir[ File.join(i.gsub('\\','/'), '{ruby.exe, ir.exe}') ].first }
				dir.should_not be_nil
				dir.should be_a(String)
			end
		end

	end

end
