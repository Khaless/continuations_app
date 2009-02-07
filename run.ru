use Rack::Session::Cookie, :key => 'session',
													 :domain => 'localhost',
													 :path => '/',
													 :expire_after => 2592000,
													 :secret => 'my_secret'

require 'continuation_app.rb'
require 'my_app.rb'
run Rack::Session::Cookie.new(ContinuationApplication::Router.new(MyApp))
