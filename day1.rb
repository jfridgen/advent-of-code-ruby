# read in file of inputs (e.g. +11\n-2\n+148\n)
# add the numbers together
# output the result

#File.foreach('day1input.txt') { |x| print "Got", x }
#numbers = File.readlines('day1input.txt')
#puts numbers.map(&:to_i).reduce(0, :+)

puts File.readlines('day1input.txt').map(&:to_i).reduce(0, :+)