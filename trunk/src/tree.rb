require 'point'
require 'branch'

class Tree
	attr_accessor :trunk, :vertices, :drawMethod
	
	# Different methods of drawing the tree
	LINES = "LINES"    # draw lines along just the main points of the branches
	WIREFRAME = "WIRE" # draw the wireframe representation of the triangles
	TRIANGLES = "TRI"  # draw the full triangles
	
	def initialize
		@trunk = Branch.new
		@drawMethod = TRIANGLES
	end
	
	def calculateLines
		self.vertices = trunk.calculateLines
	end
end