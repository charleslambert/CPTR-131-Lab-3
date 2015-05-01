require 'socket'

class Server


	def initialize()
		@server = TCPServer.new 2000
		client_hash = Hash.new
	end

	def server_run()
		loop do
  			Thread.start(@server.accept) do |client|
  				c_message = client.gets
  				s_message = command(c_message.strip, client, client_hash)
  				client.puts s_message
  				client.close
  			end
		end

	end

	def command(recieved_m, client, client_hash)
		return_m = ""

		case recieved_m

		when /CONNECT\s+(\S+)/
			return_m = connect($1, client_hash)
		when /BROADCAST\s+(\S+)/
			return_m = "SENT"
		when /SEND\s+(\S+)\s+(\S)/
			return_m = "SENT"
		when /USERLIST/
			return_m = "SENT"
		when /DISCONNECT/
			return_m = "DISCONNECTED"
		else
			return_m = "Not a valid command"
		end

		return return_m
	end


	def connect(username, client, client_hash)
		if /\s/ =~ username
			client_hash{username => client}
			return "CONNECTED"
		else
			return "FAILED"
		end
	end
end

server = Server.new
server.server_run