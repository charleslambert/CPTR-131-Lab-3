require 'socket'

class Server


	def initialize()
		@server = TCPServer.new 2000
		@client_hash = Hash.new
	end

	def server_run()
		loop do
  			Thread.start(@server.accept) do |client|
  				c_message = client.gets

  				if (/CONNECT\s+(\S+)/ =~ c_message) && (connect($1, client, @client_hash)) 					
  					while(c_message != "DISCONNECT")
  						c_message = client.gets
  						s_message = command(c_message.strip, $1, client, @client_hash)
  						client.puts s_message
  					end
  				else 
  					client.close
  				end
  			end
		end

	end

	def command(recieved_m, username, client, client_hash)
		return_m = ""

		case recieved_m

		when /BROADCAST\s+(.++)/
			broadcast($1, client_hash)
			return_m = "SENT"
		when /SEND\s+(\S+)\s+(.+)/
			#.has_key?()
			client_hash[$1].puts "SENTFROM #{username} #{$2}"
			return_m = "SENT"
		when /USERLIST/
			client.puts "USERS #{client_hash.keys.inspect}"
			return_m = "SENT"
		when /DISCONNECT/
			return_m = "DISCONNECTED"
			client.puts return_m
			client_hash.delete(username)
			client.close

		else
			return_m = "Not a valid command"
		end

		return return_m
	end


	def connect(username, client, client_hash)
		if ((/\s/ =~ username) == nil)
			client_hash[username] = client
			client.puts "CONNECTED"
			return true
		else
			client.puts "FAILED"
			return false
		end
	end

	def broadcast(message, client_hash)
		client_hash.each do |key, value|
			value.puts message
		end
	end
end

server = Server.new
server.server_run