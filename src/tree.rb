require 'point'
require 'branch'

class Tree
	attr_accessor :trunk
	
	def initialize
		@trunk = Branch.new
	end
end