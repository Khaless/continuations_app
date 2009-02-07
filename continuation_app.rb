class ContinuationApplication; end

class ContinuationApplication::Base
	def resume_with_request(request)
		@request = request
		@fiber.resume
	end
	def start
		@fiber = Fiber.new { application }
		self
	end
	def send_page(content)
		[200, { 'Content-Type' => 'text/html' }, content]
	end
	def send_page_and_wait(content)
		Fiber.yield send_page(content)
	end
end

class ContinuationApplication::Router
  def initialize(application_class)
		@application_class = application_class
		@alive_requests = {}
  end
	def call(env)
		if !env['rack.session'].has_key?(:request_id) || !@alive_requests.has_key?(env['rack.session'][:request_id])
			@alive_requests[(env['rack.session'][:request_id] = `uuid`)] = @application_class.new.start
		end
		begin
			@alive_requests[env['rack.session'][:request_id]].resume_with_request(Rack::Request.new(env))
		rescue FiberError
			@alive_requests.delete(env['rack.session'][:request_id])
			[500, { 'Content-Type' => 'text/html' }, 'Application Ended']
		end
	end
end
