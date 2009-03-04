require 'helpers/form.rb'

class MyApp < FiApp::Base

	include FiFormHelper

	def application
		@binding = binding # Default binding is now in here

		# local variables which will be collected
		# over pages
		name = nil
		age = -1
		count = 0

		# Get a Name
		while name.nil? or name.empty?
			send_page_and_wait 'one'
			name = @request.params['name']
		end

		# Get an Age
		until age > 0
			send_page_and_wait 'two'
			age = @request.params['age'].to_i
		end

		# Display their name and age
		send_page 'three', binding()
		
	end
end

