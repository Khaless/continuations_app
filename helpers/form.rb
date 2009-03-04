module FiFormHelper

	def form_start
		'<form method="post">'
	end

	def form_end
		'</form>'
	end

	# Creates a button and registers it
	# We use a stack trace to uniqly identify this button.
	# The reason is that we do not want to re-create (and reregister) it 
	# if we process a view again
	def fi_button args
		button = FiApp::FiButton.new(args)
		@listeners << button
		button.html
	end

end
