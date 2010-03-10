require "tree"

# This tree builder builds trees randomly. Each point is at a random X, Y, and Z from the previous one, within
# a given range for each coordinate. A "chance of branch" probability is given a parameter, which tells the algorithm 
# how likely it is to branch at a given point.
# 
# Finally, there is a degeneration factor given, which is between 0 and .9999, which is applied to all the
# Parameters upon each sub-branch creation. This means each sub-branch has less of a chance to have sub-branches
# and the x, y, z variations get smaller.
#
# One final wrinkle is that for the trunk, the right side of the Y variation range is doubled. That is
# to coax the trunk into growing upward more quickly
#
# The trees that are built end up being kind of fractal, more like tall shrubs.
class TreeBuilderRandomXYZ

	def self.buildTree(numPoints, xVarRange, yVarRange, zVarRange, chanceOfBranch, degenerateFactor)
		tree = Tree.new
		# Randomly decide to add a branch
		tree.trunk = createBranch(numPoints, xVarRange, yVarRange, zVarRange, 
			chanceOfBranch, degenerateFactor, true) 
		return tree
	end
	
	def self.calculatePointDiffFromRange(rangeMin, rangeMax)
		rangeWidth = rangeMax - rangeMin
		return (rangeWidth +  (rand>0.5 ? 1 : -1 )*(rand**3)*(rangeWidth))/2.0 + rangeMin
	end
	
	def self.createBranch(numPoints, xVarRange, yVarRange, zVarRange, chanceOfBranch, degenerateFactor, isTrunk)
		b = Branch.new
		b.addPoint(Point.new.build([0.0, 0.0, 0.0])) # add the root of the branch
		
		if isTrunk then yVarRange[1] = yVarRange[1] * 2.0 end
		
		(2..numPoints).each { |i|
			b.addPoint(Point.new.build([					
					b.tip.x + calculatePointDiffFromRange(xVarRange[0], xVarRange[1]),
					b.tip.y + calculatePointDiffFromRange(yVarRange[0], yVarRange[1]),
					b.tip.z + calculatePointDiffFromRange(zVarRange[0], zVarRange[1])
				]))
			
			if rand < chanceOfBranch then 
				b.tip.branch = createBranch(10*degenerateFactor, 
					[xVarRange[0]*degenerateFactor, xVarRange[1]*degenerateFactor], 
					[yVarRange[0]*degenerateFactor, yVarRange[1]*degenerateFactor], 
					[zVarRange[0]*degenerateFactor, zVarRange[1]*degenerateFactor], 
					chanceOfBranch*degenerateFactor,
					degenerateFactor, false) 
			end
		}
		
		return b
	end
	
end