require 'erubis'

module FiApp

	class Base

		def initialize
			@listeners = []
		end

		def resume_with_request(request)
			@request = request
			@fiber.resume
		end

		def start
			@fiber = Fiber.new { application }
			self
		end

		def send_page(template, binding)
			eruby = Erbinus::Eruby.new(File.read(template))
			[200, { 'Content-Type' => 'text/html' }, eruby.result(binding)]
		end

		def send_page_and_wait(template, binding)
			Fiber.yield send_page(template, binding)
		end

		def fire_event(event, target)
			@listeners.each { |obj|
				tmp = obj.fire(event, target)
				# Stop if an event returns something
				return tmp if !tmp.nil?
			}
		end

	end

	class Router

		def initialize(application_class)
			@application_class = application_class
			@alive_requests = {}
		end
		
		def call(env)
			if !env['rack.session'].has_key?(:request_id) || !@alive_requests.has_key?(env['rack.session'][:request_id])
				@alive_requests[(env['rack.session'][:request_id] = `uuid`)] = @application_class.new.start
			end
			begin
				request = Rack::Request.new(env)
				if is_event(request)
					@alive_requests[env['rack.session'][:request_id]].fire_event(request.params['__event'], request.params['__target'])
				else
					@alive_requests[env['rack.session'][:request_id]].resume_with_request(request)
				end
			rescue FiberError
				@alive_requests.delete(env['rack.session'][:request_id])
				[500, { 'Content-Type' => 'text/html' }, '<h1>Application Ended</h1>']
			end
		end

		#
		private
		#

		def is_event(request) 
			begin 
				!request.params['__event'].empty?
			rescue
				false
			end
		end

	end

	class FiFireable

		def initialize(name)
			@name = name
			@events = {}
		end

		def fire(event, target)
			begin
				@events[event.to_sym].call() 
			rescue
				nil # Did not exist, Thats ok - we return nil
			end if target == @name
		end
	end

	class FiButton < FiFireable

		def initialize args
			super(args[:name])
			args[:events].each_pair { |v|
				@events[v[0]] = v[1]
			}
		end

		def html
			"<input type=\"button\" name=\"" + @name + "\" class=\"async_button\" />"
		end

	end

end
