require 'test/unit'
require 'tree'
require 'array_helper'





     
class TestTree < Test::Unit::TestCase
	def setup
		@point = Point.new.build([2.4, 5.2, 8.9])
	end
	
	# def teardown
	# end
	
	
	def testBlankTree
		 tree = Tree.new
		 assert_equal(Branch.new, tree.trunk)
		 assert_equal(0, tree.trunk.size)
	end
	
	def testAddPoint
		# add a point using an object
		tree = Tree.new
		tree.trunk.addPoint(@point)
		assert_equal(@point, tree.trunk.root)
		assert_equal(1, tree.trunk.size)
	end
	
	# Calculate the vertices needed to draw lines of the tree
	def testCalculateLines
		# Array of points to check against
		pointArr = [
			[0.0, 0.0, 0.0],
			[0.0, 2.0, 0.0],
			[-1.0, 4.0, 0.0],
			[-1.2, 6.0, 0.0],
			# Vertices for branch at Pt [2]
			[0.0, 0.0, 0.0],
			[1.0, -0.2, 0.1],
			[1.5, -0.5, 0.5],
			[3.5, -0.7, 0.5]
		]
	
		tree = Tree.new
		tree.trunk.addPoint(Point.new.build(pointArr[0]))
		tree.trunk.addPoint(Point.new.build(pointArr[1]))
		tree.trunk.addPoint(Point.new.build(pointArr[2]))
		# add a branch at this point
		branch = Branch.new
		branch.addPoint(Point.new.build(pointArr[4]))
		branch.addPoint(Point.new.build(pointArr[5]))
		branch.addPoint(Point.new.build(pointArr[6]))
		branch.addPoint(Point.new.build(pointArr[7]))
		tree.trunk.tip.branch = branch
		tree.trunk.addPoint(Point.new.build(pointArr[3]))
		
		tree.drawMethod = Tree::LINES
		assert_equal(tree.drawMethod, Tree::LINES)
		tree.calculateLines
		
		# Expected outcome of calculateLines is the list of vertices of all the line segments to draw
		assert_equal(12, tree.vertices.size) # expect 12 vertices for 6 line segments to draw: 3 on the trunk, 3 on the branch
		assert_equal(pointArr[0], tree.vertices[0])
		assert_equal(pointArr[1], tree.vertices[1])
		
		assert_equal(pointArr[1], tree.vertices[2])
		assert_equal(pointArr[2], tree.vertices[3])
		
		# Here we expect the line segments to go off for the branch....
		# The branch points are defined relative to the place it branches off from,
		# but the vertices we expect to be absolute points in 3D space
		assert_equal(pointArr[4].math_add(pointArr[2]), tree.vertices[4])
		assert_equal(pointArr[5].math_add(pointArr[2]), tree.vertices[5])
		
		assert_equal(pointArr[5].math_add(pointArr[2]), tree.vertices[6])
		assert_equal(pointArr[6].math_add(pointArr[2]), tree.vertices[7])
		
		assert_equal(pointArr[6].math_add(pointArr[2]), tree.vertices[8])
		assert_equal(pointArr[7].math_add(pointArr[2]), tree.vertices[9])
		
		# Before continuing on to the trunk
		assert_equal(pointArr[2], tree.vertices[10])
		assert_equal(pointArr[3], tree.vertices[11])
	end
	
	def testCalculateTriangles
		#fail()
	end
	
	# Untested Methods:
	# drawing the tree
	# - as a line
	# - as circles
	# - as wireframe
	
end

