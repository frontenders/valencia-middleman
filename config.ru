require 'rubygems'

require 'rack'
require 'middleman/rack'
require 'rack/contrib/try_static'
require 'rollbar'

Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  config.disable_monkey_patch = false
end

# Build the static site when the app boots
`bundle exec middleman build`

# Enable proper HEAD responses
use Rack::Head

# Attempt to serve static HTML files
use Rack::TryStatic,
    root: 'build',
    urls: %w(/),
    try: ['.html', 'index.html', '/index.html']

# Serve a 404 page if all else fails
map '/' do
  run lambda { |_env|
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('build/index.html', File::RDONLY)
    ]
  }
end
