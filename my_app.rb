require 'form_helper.rb'

class MyApp < FiApp::Base

	include FiFormHelper

	def application

		# local variables which will be collected
		# over pages
		name = nil
		age = -1
		count = 0

		button = FiApp::FiButton.new({
			:name => "test",
			:events => {
				:click => lambda {
					p "Button Was Pressed"
					count += 1
					return [200, {"Content-Type" => "text/json"}, ['xxx yyy zzz']]
				}
			}
		})
		@listeners << button

		# Get a Name
		while name.nil? or name.empty?
			send_page_and_wait \
				'<html><head>' + \
				'<script type="text/javascript" src="/static/jquery-1.3.1.js"></script>' + \
				'<script type="text/javascript" src="/static/FiApp.js"></script>' + \
				'</head><body> What is your name (count: ' + count.to_s + ')? ' + \
				form_start + \
				'<input type="text" name="name" />' + \
				'<input type="submit">' + \
				button.html + \
				form_end + \
				'</body></html>' 
			name = @request.params['name']
		end

		# Get an Age
		until age > 0
			send_page_and_wait '<html><head></head><body>What is your age? <form method="post"><input type="text" name="age" /><input type="submit"></form></body></html>' 
			age = @request.params['age'].to_i
		end

		# Display their name and age
		send_page '<html><head></head><body>Hi ' + name + ', you are ' + age.to_s + '!</body></html>' 
		
	end
end

