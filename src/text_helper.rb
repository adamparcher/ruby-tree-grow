require 'opengl'
include Gl,Glu,Glut

# A helper class to draw text onto the screen
# Coordinates are 0, 0 at the bottom-left of the screen, 
# and increase as you move right and up the window
class TextHelper
	attr_accessor :displayHelpText
	
	def initialize
		@textColor = [1.0, 1.0, 1.0, 1.0]  # ALl white text, no other option for now
		@displayHelpText = false
	end

	def drawAll
		self.setup
		
		# Draw the text
		if @displayHelpText
			helpText =[
				"ESC - exit",
				"N - zoom out",
				"M - zoom in",
				"W/S - rotate up/down",
				"A/D - rotate left/right",
				"G - toggle plane grid display",
				"T - recreate tree(s)",
				"Press 'H' to hide Help"
			]
			rasterX = 5
			rasterY = 5
			helpText.reverse.each { |text|
				GL.RasterPos2d(rasterX, rasterY)
				text.each_byte { |x| GLUT.BitmapCharacter(GLUT_BITMAP_9_BY_15, x) }
				rasterY += 20
			}
		else
			GL.RasterPos2d(0,5)
			"Press 'H' to display Help".each_byte { |x| GLUT.BitmapCharacter(GLUT_BITMAP_9_BY_15, x) }
		end
		
		self.tearDown
	end
	
	def setup
		# Switch back to orthogonal view to draw text
		GL.MatrixMode(GL_PROJECTION)
		GL.PushMatrix; GL.LoadIdentity()
		GL.PushMatrix; glOrtho(0.0, $windowWidth, 0.0, $windowHeight, -1.0, 1.0)
		GL.MatrixMode(GL_MODELVIEW)
		GL.PushMatrix; GL.LoadIdentity
		
		# Draw the Text
		GL.Disable(GL_LIGHTING)
		GL.Color(@textColor)
	end
	
	def tearDown
		GL.Enable(GL_LIGHTING)
		GL.MatrixMode(GL_PROJECTION)
		GL.PopMatrix
		GL.PopMatrix
		GL.MatrixMode(GL_MODELVIEW)
		GL.PopMatrix
	end
end