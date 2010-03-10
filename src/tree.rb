require 'point'
require 'branch'

class Tree
	attr_accessor :trunk, :vertices, :drawMethod, :x, :y, :z
	
	# Different methods of drawing the tree
	LINES = "LINES"    # draw lines along just the main points of the branches
	WIREFRAME = "WIRE" # draw the wireframe representation of the triangles
	TRIANGLES = "TRI"  # draw the full triangles
	
	def initialize
		@trunk = Branch.new
		@drawMethod = TRIANGLES
		@treeColor = [1.0, 1.0, 1.0, 1.0]
		@x = 0.0
		@y = 0.0
		@z = 0.0
	end
	
	def calculateLines
		self.vertices = trunk.calculateLines
	end
	
	def draw
		case (@drawMethod)
			when LINES			# Draw some lines
				GL.Disable(GL_LIGHTING)   # lines get no lighting
				#GL.PushMatrix
				#GL.LoadIdentity
				GL.PushMatrix
				GL.Translate(@x, @y, @z)
				GL.Begin(GL_LINES)
				GL.Color(@treeColor)
				@vertices.each { |v|    # Assume vertices have been calculated for lines
					GL.Vertex( v[0], v[1], v[2])
				}
				GL.End
				#GL.PopMatrix
				GL.PopMatrix
				GL.Enable(GL_LIGHTING)
			when WIREFRAME
				puts "WIREFRAME: unimplemented"
			when TRIANGLES
				puts "TRIANGLES: unimplemented"
		end
	end
end