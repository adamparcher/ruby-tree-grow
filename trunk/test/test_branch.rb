require 'test/unit'
require 'branch'
require 'array_helper'
     
class TestBranch < Test::Unit::TestCase
	def setup
		@p1 = Point.new.build([0.1, 0.2, 0.3])
		@p2 = Point.new.build([1.1, 2.2, 3.3])
		@p3 = Point.new.build([3.1, 4.2, 5.3])
	end
	
	# def teardown
	# end

	def testNewBranch
		branch = Branch.new
		assert_equal(0, branch.size)
		assert_not_nil(branch.points) # this verifies that we begin with an empty array
		assert_nil(branch.root) # but the root and tip points don't exist
		assert_nil(branch.tip)
	end
	
	# Add points one at a time to a branch
	def testAddPointsOneAtATime
		branch = Branch.new
		assert_nil(branch.root)
		assert_nil(branch.tip)
		
		# add points one at a time
		branch.addPoint(@p1)
		assert_equal(1, branch.size)
		assert_not_nil(branch.points)
		assert_equal(@p1, branch.root)
		assert_equal(@p1, branch.tip)
		
		branch.addPoint(@p2)
		assert_equal(2, branch.size)
		assert_not_nil(branch.points)
		assert_equal(@p1, branch.root)
		assert_equal(@p2, branch.tip)
	end
	
	# Set the points of a Branch as an array
	def testAddPointsAsArray
		# add points all at once
		branch = Branch.new
		assert_equal(0, branch.size)
		assert_nil(branch.root)
		assert_nil(branch.tip)
		
		branch.points = [@p1, @p2, @p3]
		assert_equal(3, branch.size)
		assert_not_nil(branch.points)
		assert_equal(@p1, branch.root)
		assert_equal(@p3, branch.tip)
	end

	# Verify two different branch objects can be equal, for one point
	def testBranchEqualityOnePoint
		branch1 = Branch.new
		branch1.addPoint(Point.new.build([1.0, 2.0, 3.0]))
		branch2 = Branch.new
		branch2.addPoint(Point.new.build([1.0, 2.0, 3.0]))
		
		assert_equal(branch1, branch2)
	end
	
	# Test two blank branches are equal
	def testBranchEqualityBlank
		branch1 = Branch.new
		branch2 = Branch.new
		assert_equal(branch1, branch2)
	end
	
	# Test ability to calculate lines of vertices for a branch (and sub-branches)
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
	
		b1 = Branch.new
		b1.addPoint(Point.new.build(pointArr[0]))
		b1.addPoint(Point.new.build(pointArr[1]))
		b1.addPoint(Point.new.build(pointArr[2]))
		# add a branch at this point
		b2 = Branch.new
		b2.addPoint(Point.new.build(pointArr[4]))
		b2.addPoint(Point.new.build(pointArr[5]))
		b2.addPoint(Point.new.build(pointArr[6]))
		b2.addPoint(Point.new.build(pointArr[7]))
		b1.tip.branch = b2
		b1.addPoint(Point.new.build(pointArr[3]))
		
		vertices = b1.calculateLines
		
		# Expected outcome of calculateLines is the list of vertices of all the line segments to draw
		assert_equal(12, vertices.size) # expect 12 vertices for 6 line segments to draw: 3 on the first branch, 3 on the sub-branch
		assert_equal(pointArr[0], vertices[0])
		assert_equal(pointArr[1], vertices[1])
		
		assert_equal(pointArr[1], vertices[2])
		assert_equal(pointArr[2], vertices[3])
		
		# Here we expect the line segments to go off for the branch....
		# The branch points are defined relative to the place it branches off from,
		# but the vertices we expect to be absolute points in 3D space
		assert_equal(pointArr[4].math_add(pointArr[2]), vertices[4])
		assert_equal(pointArr[5].math_add(pointArr[2]), vertices[5])
		
		assert_equal(pointArr[5].math_add(pointArr[2]), vertices[6])
		assert_equal(pointArr[6].math_add(pointArr[2]), vertices[7])
		
		assert_equal(pointArr[6].math_add(pointArr[2]), vertices[8])
		assert_equal(pointArr[7].math_add(pointArr[2]), vertices[9])
		
		# Before continuing on to the trunk
		assert_equal(pointArr[2], vertices[10])
		assert_equal(pointArr[3], vertices[11])
	end
end

