module FiApp
	class FiButton < FiFireable

		def initialize args
			super(args[:name])
			@events = args[:events]
		end

		def html
			"<input type=\"button\" name=\"" + @name + "\" class=\"async_button\" />"
		end

	end
end
