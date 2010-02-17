require 'test/unit'
require 'tree'

     
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
	
	def testAddBranch
		#fail()
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

