require 'opengl'
include Gl,Glu,Glut

# WireGrid class draws a non-lighted wiregrid on each of the
# three planes XY, XZ, YZ.
class WireGrid
	attr_reader :gridOn

	# Set member variables to default values
	def initialize()
		@gridColorXZ = [1.0, 0.0, 0.0, 0.0] #Red
		@gridColorXY = [1.0, 1.0, 0.0, 0.0] #Yellow
		@gridColorYZ = [0.0, 0.0, 1.0, 0.0] #Blue
		@gridLines = 10  # The number of lines in HALF the grid (just to make counting easier)
		@gridSpacing = 1.0
		@gridOn = true
	end


	# Draw a grid on the XY plane from 0 to @gridLines and 0 to -@gridLines, 
	# using @gridSpacing as the amount of space to leave in between each line
	# Length of lines is calculated as width of grid = @gridLines * @gridSpacing * 2
	def drawXYGrid
		glDisable(GL_LIGHTING)
		glBegin(GL_LINES)
		glColor(@gridColorXY)
		for i in (-@gridLines..@gridLines)
			# Draw two lines for each iteration
			glVertex( i*@gridSpacing, -(@gridLines*@gridSpacing), 0.0)
			glVertex( i*@gridSpacing,  (@gridLines*@gridSpacing), 0.0)
			glVertex( -(@gridLines*@gridSpacing), i*@gridSpacing, 0.0)
			glVertex(  (@gridLines*@gridSpacing), i*@gridSpacing, 0.0)
		end
		glEnd
		glEnable(GL_LIGHTING)
	end

	# Draw grid on XZ plane
	def drawXZGrid
		glDisable(GL_LIGHTING)
		glBegin(GL_LINES)
		glColor(@gridColorXZ)
		for i in (-@gridLines..@gridLines)
			# Draw two lines for each iteration
			glVertex( i*@gridSpacing, 0.0, -(@gridLines*@gridSpacing))
			glVertex( i*@gridSpacing, 0.0,  (@gridLines*@gridSpacing))
			glVertex( -(@gridLines*@gridSpacing), 0.0, i*@gridSpacing)
			glVertex(  (@gridLines*@gridSpacing), 0.0, i*@gridSpacing)
		end
		glEnd
		glEnable(GL_LIGHTING)
	end

	# Draw grid on YZ plane
	def drawYZGrid
		glDisable(GL_LIGHTING)
		glBegin(GL_LINES)
		glColor(@gridColorYZ)
		for i in (-@gridLines..@gridLines)
			# Draw two lines for each iteration
			glVertex( 0.0, i*@gridSpacing, -(@gridLines*@gridSpacing))
			glVertex( 0.0, i*@gridSpacing,  (@gridLines*@gridSpacing))
			glVertex( 0.0, -(@gridLines*@gridSpacing), i*@gridSpacing)
			glVertex( 0.0,  (@gridLines*@gridSpacing), i*@gridSpacing)
		end
		glEnd
		glEnable(GL_LIGHTING)
	end

	# Shortcut for drawing all grids
	def drawAll
		self.drawXYGrid
		self.drawXZGrid
		self.drawYZGrid
	end
end