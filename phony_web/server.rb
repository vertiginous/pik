require 'rubygems'
require 'mongrel'
require 'pp'

class SpecialDirHandler < Mongrel::DirHandler
  
  def process(request, response)
    req_method = request.params[Mongrel::Const::REQUEST_METHOD] || Mongrel::Const::GET
    req_path = can_serve request.params[Mongrel::Const::PATH_INFO]
    if not req_path
      # not found, return a 404
      response.start(404) do |head,out|
        out << "File not found"
      end
    else
      begin
        if File.directory? req_path
          if request.params["QUERY_STRING"] =~ /group_id=(.+)/
            send_file("#{req_path}/#{$1}/index.html", request, response, false)
          else
            send_dir_listing(request.params[Mongrel::Const::REQUEST_URI], req_path, response)
          end
        elsif req_method == Mongrel::Const::HEAD
          send_file(req_path, request, response, true)
        elsif req_method == Mongrel::Const::GET
          send_file(req_path, request, response, false)
        else
          response.start(403) {|head,out| out.write(ONLY_HEAD_GET) }
        end
      rescue => details
        STDERR.puts "Error sending file #{req_path}: #{details}"
      end
    end
  end  
end

dir = File.join(File.dirname(__FILE__), 'public')
puts "Starting Phony web server on port 80"
h = Mongrel::HttpServer.new("0.0.0.0", "80")
h.register("/", SpecialDirHandler.new(dir))
h.run.join