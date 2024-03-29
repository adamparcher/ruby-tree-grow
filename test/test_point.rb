require 'test/unit'
require 'point'
require 'branch'
     
class TestPoint < Test::Unit::TestCase
	# def setup
	# end
	
	# def teardown
	# end
	
	def testNewBlankPoint
		point = Point.new
		assert_equal(0.0, point.x)
		assert_equal(0.0, point.y)
		assert_equal(0.0, point.z)
		assert_nil(point.branch)
	end
	
	def testNewPoint
		point = Point.new
		point.x = 1.2
		point.y = 4.5
		point.z = 7.8
		assert_equal(1.2, point.x)
		assert_equal(4.5, point.y)
		assert_equal(7.8, point.z)
	end
	
	def testBuildPoint
		point = Point.new.build([1.2, 4.5, 7.8])
		assert_equal(1.2, point.x)
		assert_equal(4.5, point.y)
		assert_equal(7.8, point.z)
	end
	
	# Test equality in points, if they have the same x, y, z values, they are equal
	def testPointEquality
		# Test blank points
		point1 = Point.new
		point2 = Point.new
		assert_equal(point1, point2)
	
		# Test same point values
		point1 = Point.new.build([1.2, 4.5, 7.8])
		point2 = Point.new.build([1.2, 4.5, 7.8])
		assert_equal(point1, point2)
		
		# Change x, y, z values independently
		point1.x = 0.7
		assert_not_equal(point1, point2)
		point1.x = 1.2
		assert_equal(point1, point2)
		point1.y = 3.2
		assert_not_equal(point1, point2)
		point1.y = 4.5
		assert_equal(point1, point2)
		point1.z = 4.4
		assert_not_equal(point1, point2)
		point1.z = 7.8
		assert_equal(point1, point2)
	end
	
	# A Point can have 0 to many Branch objects attached to it
	def testAddBranch
		point = Point.new
		assert_nil(point.branch)
		branch = Branch.new
		branch.addPoint(Point.new.build([0.0, 0.0, 0.0]))
		branch.addPoint(Point.new.build([1.0, -0.2, 0.1]))
		branch.addPoint(Point.new.build([1.5, -0.5, 0.5]))
		branch.addPoint(Point.new.build([3.5, -0.7, 0.5]))
		point.branch = branch
		assert_equal(branch, point.branch)
	end
	
	
	def testAsArray
		point = Point.new.build([1.2, 4.5, 7.8])
		assert_equal([1.2, 4.5, 7.8], point.as_array)
	end
end

