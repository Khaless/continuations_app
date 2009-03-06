require 'helpers/form.rb'

class MysqlApp < FiApp::Base

	include FiFormHelper

	def application
		@binding = binding # Default binding inside this method

		# When an instance of an application starts, make
		# a connection to the database (note: a better idea
		# is to use a pool.
		
		while true 
			# Display a list of people, we assume the next
			# step is to click on a person's name.
			#listofpeople
			send_page_and_wait 'list_of_people'
			
			# Display details about this person
			# and allow edit.
			send_page_and_wait 'person_details'
		end
		
	end
end

