require 'socket'

class Server
	def initilaze
		@server = TCPServer.new 2000
	end

