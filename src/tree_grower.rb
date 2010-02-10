#!/usr/bin/env ruby -rubygems
require 'opengl'
require 'tree'
require 'wiregrid'
require 'text_helper'
include Gl,Glu,Glut

$light_diffuse0 = [1.0, 0.0, 1.0, 1.0]
$light_position0 = [1.0, 1.0, 1.0, 0.0]

$light_diffuse1 = [0.0, 1.0, 0.2, 1.0]
$light_position1 = [-1.0, -0.7, -1.0, 0.0]

$n = [ 
	[-1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [1.0, 0.0, 0.0],
	[0.0, -1.0, 0.0], [0.0, 0.0, 1.0], [0.0, 0.0, -1.0] ]
$faces = [
	[0, 1, 2, 3], [3, 2, 6, 7], [7, 6, 5, 4],
	[4, 5, 1, 0], [5, 6, 2, 1], [7, 4, 0, 3] ]
$v = 0
$zoom = -1.0
$xrot = 80
$zrot = -20

$windowWidth = 700.0
$windowHeight = 500.0

$wiregrid = WireGrid.new
$textHelper = TextHelper.new

def drawBox
	for i in (0..5)
		GL.Begin(GL_QUADS)
		GL.Normal(*($n[i]))
		GL.Vertex($v[$faces[i][0]])
		GL.Vertex($v[$faces[i][1]])
		GL.Vertex($v[$faces[i][2]])
		GL.Vertex($v[$faces[i][3]])
		GL.End()
	end
end

redraw = Proc.new do
end

reshape = Proc.new do |w, h|
	puts "reshaping, width=#{w}, height=#{h}"
	$windowWidth = w*1.0    # convert to float
	$windowHeight = h*1.0   # convert to float
	# Set the view perspective
	GL.MatrixMode(GL_PROJECTION)
	GL.LoadIdentity()
	GLU.Perspective(40.0, $windowWidth/$windowHeight, 1.0,  100.0)
	GL.MatrixMode(GL_MODELVIEW)
end

display = Proc.new do
	puts "drawing: xrot=#{$xrot}, zrot=#{$zrot}, zoom=#{$zoom}"
	
	# Clear display buffer
	GL.Clear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
		
	# Position and Point the camera
	GL.LoadIdentity()
	GLU.LookAt(2.0, 3.0, 5.0, # Camera coords
		0.0, 0.0, 0.0,	      # Point to look at
		0.0, 1.0, 0.0)        # Which way is 'up'
	
	# Draw the grid
	$wiregrid.drawAll
	
	# Draw the Help text
	$textHelper.drawAll
	
	# Draw a Box
	drawBox
		
	# Finally swap the zbuffer and display the scene!
	GLUT.SwapBuffers
end

def myinit
	$v = [[-1, -1,1],[-1, -1,-1], [-1,1,-1], [-1,1,1], [1, -1,1],
		[1, -1,-1], [1, 1,-1], [1,1,1]]

	# Light 0
	GL.Light(GL_LIGHT0, GL_DIFFUSE, $light_diffuse0)
	GL.Light(GL_LIGHT0, GL_POSITION, $light_position0)
	GL.Enable(GL_LIGHT0)
	
	# Light 1
	GL.Light(GL_LIGHT1, GL_DIFFUSE, $light_diffuse1)
	GL.Light(GL_LIGHT1, GL_POSITION, $light_position1)
	GL.Enable(GL_LIGHT1)
	
	GL.Enable(GL_LIGHTING)
	GL.Enable(GL_DEPTH_TEST)
end

keyboard = Proc.new do |key, x, y|
	puts "#{key} - #{x} - #{y}"
	case (key)
		when ?\e
		exit(0);
		when ?o
		$xrot-=10;
		GLUT.PostRedisplay
		when ?p
		$xrot+=10;
		GLUT.PostRedisplay
		when ?k
		$zrot-=10;
		GLUT.PostRedisplay
		when ?l
		$zrot+=10;
		GLUT.PostRedisplay
		when ?n
		$zoom-=1;
		GLUT.PostRedisplay
		when ?m
		$zoom+=1;
		GLUT.PostRedisplay
		when ?h # toggle Help Text display
			$textHelper.displayHelpText = !$textHelper.displayHelpText
			GLUT.PostRedisplay
	end
end

glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
glutInitWindowSize($windowWidth, $windowHeight)
glutInitWindowPosition(100, 100)
glutCreateWindow("Tree Grower")
glutReshapeFunc(reshape)
glutDisplayFunc(display)
glutKeyboardFunc(keyboard)
myinit
glutMainLoop()
