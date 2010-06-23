# require "net/http"

# Example Usage:

# use Rack::Proxy do |req|
# if req.path =~ %r{^/remote/service.php$}
# URI.parse("http://remote-service-provider.com/service-end-point.php?#{req.query}")
# end
# end
#
# run proc{|env| [200, {"Content-Type" => "text/plain"}, ["Ha ha ha"]] }
#

require 'rack/cache'
require 'logger'

module Rack::Cache
  class Request < Rack::Request
    # True when the Cache-Control/no-cache directive is present or the
    # Pragma header is set to no-cache.
    def no_cache?
      false
    end
  end
  
  class Response
    # Determine if the response is "fresh". Fresh responses may be served from
    # cache without any interaction with the origin. A response is considered
    # fresh when it includes a Cache-Control/max-age indicator or Expiration
    # header and the calculated age is less than the freshness lifetime.
    def fresh?
      true
    end
  end
end

use Rack::Cache,
  :verbose => false,
  :metastore => 'file:C:/temp/proxy/meta',
  :entitystore => 'file:C:/temp/proxy/entity'

class Rack::Proxy
  def initialize(app, &block)
    self.class.send(:define_method, :uri_for, &block)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    method = req.request_method.downcase
    method[0..0] = method[0..0].upcase
    return @app.call(env) unless uri = uri_for(req)
    # env['rack.errors'].write(uri.query)
    sub_request = Net::HTTP.const_get(method).new("#{uri.path}#{"?" if uri.query}#{uri.query}")

    if sub_request.request_body_permitted? and req.body
      sub_request.body_stream = req.body
      sub_request.content_length = req.content_length
      sub_request.content_type = req.content_type
    end

    sub_request["X-Forwarded-For"] = (req.env["X-Forwarded-For"].to_s.split(/, +/) + [req.env['REMOTE_ADDR']]).join(", ")
    sub_request["Accept-Encoding"] = req.accept_encoding
    sub_request["Referer"] = req.referer

    sub_response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(sub_request)
    end

    headers = {}
    sub_response.each_header do |k,v|
      headers[k] = v unless k.to_s =~ /status|cookie|content-length|transfer-encoding/i
    end

    [sub_response.code.to_i, headers, [sub_response.read_body]]
  end
end

proxy = use(Rack::Proxy){ |req| URI.parse(req.url) }

run proxy