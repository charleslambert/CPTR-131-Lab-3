require 'socket'

class Server

	def initialize()
		@server = TCPServer.new 2000
		@client_hash = Hash.new
	end

	def run()
		loop do
  			Thread.start(@server.accept) do |client|
  			#A thread is created to handle each user who connects.
  				username = connect(client, @client_hash)
  				#Connect allows the user to attempt a connection until 
  				#a connection is made(only require is a valid username).
  				#A valid username has no spaces and is not already connected=
  				loop {
  					#A loop that is the basically the connected state of a client.
  					#A server recieves message/command and it interprets it with the
  					#the command function which returns either the return message for the 
  					#client or nil
  					client_message = client.gets.chomp
  					server_message = command(client_message, username, client, @client_hash)
  					#Determines if a return message needs to be sent to the client
  					if (server_message != nil)
  						client.puts server_message
  					end
  				}
  			end
		end

	end


	def command(recieved_message, username, client, client_hash)

		case recieved_message

		when /BROADCAST\s+(.+)/
			return_message = broadcast($1, username, client_hash)
		when /SEND\s+(\S+)\s+(.+)/
			return_message = send(client_hash, username, $1, $2)
		when /USERLIST/
			return_message = userlist(client_hash)
		when /DISCONNECT/
			return_message = disconnect(client_hash, username, client)
		when /RECIEVED/
			return_message = nil
			puts recieved_message
		when /SHUTDOWN\s+(.+)/
			return_message = shutdown(client_hash, $1)
		else
			return_message = "Not a valid command"
		end

		return return_message
	end

	def connect(client, client_hash)
		connected = false

		while(connected == false)
		#Loop allows the user to continually try to connect
		#until they are able to successfully connect.
			client_message = client.gets
			
			if (/CONNECT\s+(\S+)/ =~ client_message.strip && (client_hash.has_key?($1) != true))
			#If the client message is of the correct form and does not already exist
			#the clients username is added to the client_hash and client is told they have 
			#connected successfully. 
 				client_hash[$1] = client
				client.puts "CONNECTED #{$1}"
				connected = true
				return $1

			elsif (/RECIEVED/ =~ client_message)
			#Server puts the recieved message issued from the client when either 
			#the message for a successful connection or failed connection.
				puts client_message
			else
			#If the client fails to connect the server tells them.
				client.puts "FAILED"
				connected = false
			end
		end
	end

	def broadcast(message, username, client_hash)
	#Broadcast takes the message it is given and sends it to each client in the 
	#client_hash and returns SENT.
		client_hash.each { |key, value|
			value.puts "BROADCASTED #{username} #{message}"
		}
		return "SENT"
	end

	def send(client_hash, username, user_to, message)
	#Send takes the message it is given and sends it to the approiate 
	#recipiant if they exists in the client_hash and returns SENT or FAIlED.
		if (client_hash.has_key?(user_to))
			client_hash[user_to].puts "SENTFROM #{username} #{message}"
			return "SENT"
		else 
			return "FAILED #{user_to} is not a user."
		end
	end

	def userlist(client_hash)
	#Returns the userlist.
		return "USERS #{client_hash.keys.inspect}"
	end

	def disconnect(client_hash, username, client)
	#Deletes the clients username from the client hash and returns DISCONNECTED 
	#message to the user.
		client_hash.delete(username)
		client.puts "DISCONNECTED #{username}"
		puts client.gets.chomp
		Thread.kill self
	end

	def shutdown(client_hash, passcode)
		if passcode == "6359"
			client_hash.each { |key, value| 
				value.puts "STOPPING"
			}
			exit
		else 
			return "Invalid passcode"
		end
	end
end
