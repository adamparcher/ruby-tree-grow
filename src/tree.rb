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
		@treeColor = [1.0, 1.0, 1.0, 1.0]
	end
	
	def calculateLines
		self.vertices = trunk.calculateLines
	end
	
	def draw
		case (@drawMethod)
			when LINES			# Draw some lines
				glDisable(GL_LIGHTING)   # lines get no lighting
				glBegin(GL_LINES)
				glColor(@treeColor)
				@vertices.each { |v|    # Assume vertices have been calculated for lines
					glVertex( v[0], v[1], v[2])
				}
				glEnd
				glEnable(GL_LIGHTING)
			when WIREFRAME
				puts "WIREFRAME: unimplemented"
			when TRIANGLES
				puts "TRIANGLES: unimplemented"
		end
	end
end