require 'socket'

class Client

	def initialize()
		@server = TCPSocket.new 'localhost', 2000
		@request = nil
		@response = nil
	end

	def client_run()
		connect(@server)
		recieve()
		send()
		@request.join
		@response.join
		#Ensure the completion all threads
	end

	def connect(server)
		connected = false
		while (connected != true)
			attempt = gets.chomp
			server.puts attempt
			con_or_fail = server.gets
			if /CONNECTED/ =~ con_or_fail
				connected = true
			else
				connected = false
			end
			puts con_or_fail
			server.puts "RECIEVED"
		end
	end

	def recieve()
	#Waits for server responses. 
	#If the server sends a message, it is put to screen
	#and the message RECIEVED is returned.
	#If the message DISCONNECTED is recieved the client is shut down.
		@response = Thread.new {
			loop {
				message = @server.gets.chomp
				puts message
				@server.puts "RECIEVED"
	
				if (/DISCONNECTED/ =~ message)
					@server.close
					exit
				end
			}
		}
	end

	def send()
	#Waits for client input. When client enters a message the
	#message is sent to the server.
		@request = Thread.new {
			loop {
				message = gets.chomp
				@server.puts message
			}
		}
	end
end

Client.new.client_run