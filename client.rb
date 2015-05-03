require 'socket'

class Client

	def initialize()
		@server = TCPSocket.new 'localhost', 2000
	end

	def client_run()

		connect(@server)
		
		thr = nil
		
		loop do
			if ((s_message = @server.gets).strip != nil)
				puts s_message.strip
				@server.puts "RECIEVED"
			end

			if (/DISCONNECTED*/ =~ s_message)
				@server.close
				exit
			end

			if(thr == nil)
				thr = Thread.new {
					user_input = gets.chomp
					@server.puts user_input
					thr = nil
				}
			end
		end
	end

	def connect(server)
		connected = false
		while (connected != true)
			attempt = gets.chomp
			server.puts attempt
			if /CONNECTED*/ =~ server.gets
				connected = true
			else
				connected = false
			end
			server.puts "RECIEVED"
		end
	end
end

Client.new.client_run