require 'socket'

class Client

	def initialize()
		@server = TCPSocket.new 'localhost', 2000
	end

	def client_run()
		loop do
			user_input = gets.chomp
			@server.puts user_input
			s_message = @server.gets
			puts s_message
		end
	end

	def command(s_message)
	end

end

Client.new.client_run