class MyApp < ContinuationApplication::Base
	def application

		# local variables which will be collected
		# over pages
		name = nil
		age = -1

		# Get a Name
		while name.nil? and name != ""
			send_page_and_wait '<html><head></head><body> What is your name? <form method="post"><input type="text" name="name" /><input type="submit"></form></body></html>' 
			name = @request.params['name']
		end

		# Get an Age
		until age > 0
			send_page_and_wait '<html><head></head><body>What is your age? <form method="post"><input type="text" name="age" /><input type="submit"></form></body></html>' 
			age = @request.params['age'].to_i
		end
		send_page '<html><head></head><body>Hi ' + name + ', you are ' + age.to_s + '!</body></html>' 
		
	end
end

