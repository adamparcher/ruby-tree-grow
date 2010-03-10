#!/usr/bin/env ruby -rubygems
require 'opengl'
require 'tree'
require 'wiregrid'
require 'text_helper'
require 'array_helper'
# require all tree builders
Dir[File.dirname(__FILE__) + '/tree_builder_*.rb'].each { |tree_builder| 
	require tree_builder
}



#############
#  GLOBAL VARIABLES
#
$windowWidth = 700.0
$windowHeight = 500.0

$light_diffuse0 = [1.0, 0.0, 1.0, 1.0]
$light_position0 = [1.0, 1.0, 1.0, 0.0]

$light_diffuse1 = [0.0, 1.0, 0.2, 1.0]
$light_position1 = [-1.0, -0.7, -1.0, 0.0]


############
#  VARIABLES TO HOLD CAMERA LOCATION/ROTATION
# 
$zoom = 80.0
ZOOM_INTERVAL = 1.0
ZOOM_RANGE = 1..100
$upDownRotation = 10.0    # The initial up/down rotation in degrees
UP_DOWN_ROTATION_INTERVAL = 5.0 
UP_DOWN_RANGE = -90..90
$leftRightRotation = -20.0 # Initial left/right rotation in degrees
LEFT_RIGHT_ROTATION_INTERVAL = 5.0
LEFT_RIGHT_RANGE = -64000..640000


#############
#  GLOBAL VARIABLES TO CONTAIN DRAWABLE OBJECTS
#
$wiregrid = WireGrid.new
$textHelper = TextHelper.new

# Global variable to hold the trees to draw
$trees = []
def setupTree
	# Set up the tree to draw
	
	# Example 1: Load a tree from a YAML file
	#     $tree1 = YAML::load_file "./sample_trees/simple_fir.tree"
	
	# Example 2: Create a tree manually
	#     $tree1 = Tree.new
	#
	#			[0.0, 0.0, 0.0],
	#			[0.0, 2.0, 0.0],
	#			[-1.0, 4.0, 0.0],
	#			[-1.2, 6.0, 0.0],
	#			# Vertices for branch at Pt [2]
	#			[0.0, 0.0, 0.0],
	#			[1.0, -0.2, 0.1],
	#			[1.5, -0.5, 0.5],
	#			[3.5, -0.7, 0.5]
	#		]
	#	
	#		$tree1 = Tree.new
	#		$tree1.trunk.addPoint(Point.new.build(pointArr[0]))
	#		$tree1.trunk.addPoint(Point.new.build(pointArr[1]))
	#		$tree1.trunk.addPoint(Point.new.build(pointArr[2]))
	#		# add a branch at this point
	#		branch = Branch.new
	#		branch.addPoint(Point.new.build(pointArr[4]))
	#		branch.addPoint(Point.new.build(pointArr[5]))
	#		branch.addPoint(Point.new.build(pointArr[6]))
	#		branch.addPoint(Point.new.build(pointArr[7]))
	#		$tree1.trunk.tip.branch = branch
	#		$tree1.trunk.addPoint(Point.new.build(pointArr[3]))
	
	# Example 3: Call a TreeBuilder method to build a tree
	# Define some parameters
	numberPoints = 20
	trunkXVarRange = [-4.0, 4.0] # The min/max range the Trunk's X can change each time
	trunkYVarRange = [1.0, 2.0]
	trunkZVarRange = [-4.0, 4.0]
	chanceOfBranch = 0.5		
	degenerateFactor = 0.5
	
	
	# Build 4 trees spaces around the 'ground'
	$trees = []
	t = TreeBuilderRandomXYZ.buildTree(numberPoints, trunkXVarRange, trunkYVarRange, trunkZVarRange, chanceOfBranch, degenerateFactor)
	t.x = 30.0
	$trees.push t
	t = TreeBuilderRandomXYZ.buildTree(numberPoints, trunkXVarRange, trunkYVarRange, trunkZVarRange, chanceOfBranch, degenerateFactor)
	t.z = 30.0
	$trees.push t
	t = TreeBuilderRandomXYZ.buildTree(numberPoints, trunkXVarRange, trunkYVarRange, trunkZVarRange, chanceOfBranch, degenerateFactor)
	t.z = -30.0
	$trees.push t
	t = TreeBuilderRandomXYZ.buildTree(numberPoints, trunkXVarRange, trunkYVarRange, trunkZVarRange, chanceOfBranch, degenerateFactor)
	t.x = -30.0
	$trees.push t
	
	$trees.each { |t| 
		t.drawMethod = Tree::LINES
		t.calculateLines
		#DEBUG
		puts "DEBUG: Current Tree---"
		puts t.to_yaml
	}
	
end


###########
#  RESHAPE METHOD IS CALLED WHEN WINDOW SIZE CHANGES
#
reshape = Proc.new do |w, h|
	puts "reshaping, width=#{w}, height=#{h}"
	$windowWidth = w*1.0    # convert to float
	$windowHeight = h*1.0   # convert to float
	# Set the view perspective
	GL.MatrixMode(GL_PROJECTION)
	GL.LoadIdentity()
	GLU.Perspective(60.0, $windowWidth/$windowHeight, 1.0,  200.0)
	GL.MatrixMode(GL_MODELVIEW)
end


###########
#  METHODS TO DRAW OBJECTS
#
def drawTree
	$trees.each { |t| t.draw }
end


display = Proc.new do
	puts "drawing: upDownRotation=#{$upDownRotation}, leftRightRotation=#{$leftRightRotation}, zoom=#{$zoom}"
	
	# Clear display buffer
	GL.Clear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
		
	# Position and Point the camera
	# Method for positioning is to first set camera to be placed back
	# along the Z axis, at x=0, y=0
	# Then, perform the up/down rotation based on $upDownRotation
	# Finally, rotate around left/right based on $leftRightRotation
	GL.LoadIdentity()
	# Position camera first
	GLU.LookAt(0.0, 0.0, $zoom, # Camera coords
		0.0, 10.0, 0.0,	      # Point to look at
		0.0, 1.0, 0.0)        # Which way is 'up'
	# Rotate up/down (on x-axis)
	GL.Rotate($upDownRotation, 1.0, 0.0, 0.0)
	# Rotate left/right (on y-axis)
	GL.Rotate($leftRightRotation, 0.0, 1.0, 0.0)
	
	# Draw the grid
	$wiregrid.drawAll
	
	# Draw the Help text
	$textHelper.drawAll
	
	# Draw some stuff!
	drawTree
		
	# Finally swap the zbuffer and display the scene!
	GLUT.SwapBuffers
end

# Out initialization function
# - Set up the vertices for our box to draw
# - Set up all the lights
def myinit
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

# Callback function for processing key-presses
keyboard = Proc.new do |key, x, y|
	puts "#{key} - #{x} - #{y}"
	case (key)
		when ?\e
			exit(0);
		when ?m, ?M     # ZOOM IN
			$zoom += ZOOM_INTERVAL
			# check if we've moved past the top end of the valid range
			if !ZOOM_RANGE.include?($zoom) then $zoom = ZOOM_RANGE.max end
		when ?n, ?N     # ZOOM OUT
			$zoom -= ZOOM_INTERVAL
			# check if we've moved past the bottom end of the valid range
			if !ZOOM_RANGE.include?($zoom) then $zoom = ZOOM_RANGE.min end
		when ?w, ?W     # TILT UP
			$upDownRotation += UP_DOWN_ROTATION_INTERVAL
			# check if we've moved past the bottom end of the valid range
			if !UP_DOWN_RANGE.include?($upDownRotation) then $upDownRotation = UP_DOWN_RANGE.max end
		when ?s, ?S     # TILT DOWN
			$upDownRotation -= UP_DOWN_ROTATION_INTERVAL
			# check if we've moved past the top end of the valid range
			if !UP_DOWN_RANGE.include?($upDownRotation) then $upDownRotation = UP_DOWN_RANGE.min end
		when ?a, ?A     # ROTATE LEFT
			$leftRightRotation += LEFT_RIGHT_ROTATION_INTERVAL
			# check if we've moved past the bottom end of the valid range
			if !LEFT_RIGHT_RANGE.include?($leftRightRotation) then $leftRightRotation = LEFT_RIGHT_RANGE.max end
		when ?d, ?D     # ROTATE RIGHT
			$leftRightRotation -= LEFT_RIGHT_ROTATION_INTERVAL
			# check if we've moved past the top end of the valid range
			if !LEFT_RIGHT_RANGE.include?($leftRightRotation) then $leftRightRotation = LEFT_RIGHT_RANGE.min end
		when ?g, ?G     # TOGGLE WIREFRAME PLANE GRID
			$wiregrid.toggle
		when ?t, ?T     # REGENERATE THE TREE
			setupTree
		when ?h, ?H     # TOGGLE HELP
			$textHelper.displayHelpText = !$textHelper.displayHelpText
	end
	GLUT.PostRedisplay
end

# Initialize, set our callback methods, and kick off the main loop!
glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH)
glutInitWindowSize($windowWidth, $windowHeight)
glutInitWindowPosition(100, 100)
glutCreateWindow("Tree Grower")
glutReshapeFunc(reshape)
glutDisplayFunc(display)
glutKeyboardFunc(keyboard)
myinit
setupTree
glutMainLoop()
