require 'socket'

class Server

	def initialize()
		@server = TCPServer.new 2000
		@client_hash = Hash.new
	end

	def server_run()
		loop do
  			Thread.start(@server.accept) do |client|

  				username = connect(client, @client_hash)

  				c_message = ""

  				while(c_message != /DISCONNECTED/)
  					c_message = client.gets
  					c_message = command(c_message.strip, username, client, @client_hash)
  					if (c_message != nil)
  						client.puts c_message
  					end
  				end
  			end
		end

	end


	def command(recieved_m, username, client, client_hash)

		case recieved_m

		when /BROADCAST\s+(.++)/
			return_m = broadcast($1, username, client_hash)
		when /SEND\s+(\S+)\s+(.+)/
			return_m = send(client_hash, username, $1, $2)
		when /USERLIST/
			return_m = userlist(client_hash, client)
		when /DISCONNECT/
			return_m = disconnect(client_hash, client, username)
		when /RECIEVED/
			return_m = nil
			puts recieved_m
		else
			return_m = "Not a valid command"
		end

		return return_m
	end

	def connect(client, client_hash)
		connected = false

		while(connected == false)

			c_message = client.gets
			
			if (/CONNECT\s+(\S+)/ =~ c_message && client_hash.has_key?($1) != true) 
 				client_hash[$1] = client
				client.puts "CONNECTED #{$1}"
				connected = true
				return $1
			else
				client.puts "FAILED"
				connected = false
			end
		end
	end

	def broadcast(message, username, client_hash)
		client_hash.each do |key, value|
			value.puts "#{username} #{message}"
		end
		return "SENT"
	end

	def send(client_hash, username, user_to, message)
		if (client_hash.has_key?(user_to))
			client_hash[user_to].puts "SENTFROM #{username} #{message}"
			return "SENT"
		else 
			return "FAILED #{user} is not a user."
		end
	end

	def userlist(client_hash, client)
		return "USERS #{client_hash.keys.inspect}"
	end

	def disconnect(client_hash, client, username)
		client_hash.delete(username)
		return "DISCONNECTED #{username}"
	end

end

server = Server.new
server.server_run