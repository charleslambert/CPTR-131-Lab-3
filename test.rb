require_relative "client.rb"
require_relative "server.rb"
require "test/unit"
require 'socket'

class TestServerAndClient < Test::Unit::TestCase

	def setup
		@server = Server.new
		@hash = {"Jim"=>@socket}
		@user = "Jim"
		@socket = TCPSocket.new "localhost", 2000
	end

	def teardown
	end


	def test_userlist
		assert_equal("USERS [\"Jim\"]", @server.userlist(@hash))
		@hash["mack"] = TCPSocket.new "localhost", 2000
		assert_equal("USERS [\"Jim\", \"mack\"]", @server.userlist(@hash))
	end
	
	#I was unable to test the other funcitons becuase they use gets and puts 
end