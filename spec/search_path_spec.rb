require 'lib/rem/search_path'

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
		it "should replace one element with another using a regex" do
			path =	'C:\ruby\191\bin'
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
			updated_path = @path.replace(/ruby/i, path).join
			updated_path.should == new_path
		end

		it "should replace one element with another using a string" do
			path =	'C:\ruby\191\bin'
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
			updated_path = @path.replace('C:\ruby\186-mswin32\bin', path).join
			updated_path.should == new_path
		end
	end

	describe '#add' do
		it "should add an element to the end" do
			path =	'C:\ruby\191\bin'
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
			new_path <<	'C:\ruby\186-mswin32\bin;'
			new_path <<	'C:\Program Files\Putty;'
			new_path <<	'C:\ruby\191\bin'
			@path.add(path)
			@path.join.should == new_path
		end
	end

	describe '#replace_or_add' do
		it "should replace one element with another using a regex" do
			path =	'C:\ruby\191\bin'
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
			@path.replace_or_add(/ruby/i, path)
			@path.join.should == new_path
		end

		it "should replace one element with another using a string" do
			path =	'C:\ruby\191\bin'
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
			@path.replace_or_add('C:\ruby\186-mswin32\bin', path)
			@path.join.should == new_path
		end

		it "should add an element to the end if it doesn't already exist" do
			path =	'C:\xray\yankee\zebra'
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
			new_path <<	'C:\ruby\186-mswin32\bin;'
			new_path <<	'C:\Program Files\Putty;'
			new_path <<	'C:\xray\yankee\zebra'
			@path.replace_or_add(/xray/i, path)
			@path.join.should == new_path
		end

	end

end
