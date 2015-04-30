require 'socket'

class Server


	def initialize()
		@server = TCPServer.new 2000
		client_hash = Hash.new


		sever_run(server, client_hash)
	end

	def server_run(server)


	end


end