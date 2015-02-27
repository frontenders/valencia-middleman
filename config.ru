require "rubygems"

require "rack"
require "middleman/rack"
require "rack/contrib/try_static"

Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
end

# Build the static site when the app boots
`bundle exec middleman build`

# Enable proper HEAD responses
use Rack::Head
# Attempt to serve static HTML files

use Rack::TryStatic,
    :root => "build",
    :urls => %w[/],
    :try => ['.html', 'index.html', '/index.html']

# Serve a 404 page if all else fails
map "/" do
  run lambda { |env|
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

map "/event.html" do
  run lambda { |env|
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('build/event.html', File::RDONLY)
    ]
  }
end

map "/past.html" do
  run lambda { |env|
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Cache-Control' => 'public, max-age=86400'
      },
      File.open('build/past.html', File::RDONLY)
    ]
  }
end

run lambda { |env|
  [
    404,
    {
      "Content-Type" => "text/html",
      "Cache-Control" => "public, max-age=60"
    },
    File.open("build/404.html", File::RDONLY)
  ]
}
