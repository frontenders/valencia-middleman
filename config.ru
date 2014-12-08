require 'rack'
require 'rack/contrib/try_static'
 
use ::Rack::TryStatic,
:root => "build", # where middleman files are generated
:urls => %w[/] # match all requests
:try => ['.html', 'index.html', '/index.html'] # try these postfixes sequentially
# 404
run lambda { [404, {'Content-Type' => 'text/plain'}, [' File not found.']]} 