require 'point'

class Branch
	attr_accessor :points
	attr_reader :root, :tip
	
	def initialize
		@points = []
	end
	
	 def addPoint(newPoint)
	 	@points.push newPoint
	 end
	 
	 def size
	 	return @points.length
	 end
	 
	 def root
	 	return @points.first
	 end
	 
	 def tip
	 	return @points.last
	 end
	 
	 def ==(otherBranch)
	 	return @points == otherBranch.points
	 end
end
