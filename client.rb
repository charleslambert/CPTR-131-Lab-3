require 'socket'

class Client

	def initialize()
		@server = TCPSocket.new 'localhost', 2000
	end

	def client_run()

		connect(@server)
		puts "pewdipie"
		server_input = nil
		client_input = nil
		loop do		
			if(server_input == nil)
				server_input = Thread.new{	
					if ((s_message = @server.gets).strip != nil)
						puts s_message.strip
						@server.puts "RECIEVED"
					end
					if (/DISCONNECTED*/ =~ s_message)
						@server.close
						exit
					end
					server_input = nil
				}
			end

			if(client_input == nil)
				client_input = Thread.new {
					user_input = gets.chomp
					@server.puts user_input
					client_input = nil
				}
			end
		end
	end

	def connect(server)
		connected = false
		while (connected != true)
			attempt = gets.chomp
			server.puts attempt
			c_or_f = server.gets
			puts c_or_f
			if /CONNECTED/ =~ c_or_f
				connected = true
			else
				connected = false
			end
			server.puts "RECIEVED"
		end
	end
end

Client.new.client_run