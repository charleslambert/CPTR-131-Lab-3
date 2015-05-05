thr = Thread.new {
	stuff = gets.chomp
	puts stuff
}

loop do
	puts thr
end