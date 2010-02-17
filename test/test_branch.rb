require 'test/unit'
require 'branch'
     
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
end

