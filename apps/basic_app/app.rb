require 'lib/helpers/form.rb'

class BasicApp < FiApp::Base

	include FiFormHelper

	def application
		@binding = binding # Default binding inside this method

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
		send_page 'three', {:name => name, :age => age, :count => count} # in this send_page, we define our own binding
		
	end
end

