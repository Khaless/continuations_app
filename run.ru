use Rack::Session::Cookie, :key => 'session',
													 :domain => 'localhost',
													 :path => '/',
													 :expire_after => 2592000,
													 :secret => 'my_secret'

require 'fi_app.rb'
require 'my_app.rb'
app = Rack::URLMap.new('/app' => Rack::Session::Cookie.new(FiApp::Router.new(MyApp)),
											 '/static' => Rack::File.new('./static'))
Thin::Server.start('0.0.0.0', 3000, app)

