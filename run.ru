use Rack::Session::Cookie, :key => 'session',
													 :domain => 'localhost',
													 :path => '/',
													 :expire_after => 2592000,
													 :secret => 'my_secret'


require 'lib/core/fi_app.rb'
require 'lib/widgets/fi_button.rb'

# Apps
require 'apps/basic_app/app.rb'

app = Rack::URLMap.new('/basic_app' => Rack::Session::Cookie.new(FiApp::Router.new(BasicApp)),
											 '/static' => Rack::File.new('./static'))
Thin::Server.start('0.0.0.0', 3000, app)

