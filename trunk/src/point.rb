class Point
	attr_accessor :x, :y, :z
	
	def initialize
		@x = 0.0
		@y = 0.0
		@z = 0.0
	end
	
	def build(pointsarray)
		@x = pointsarray[0]
		@y = pointsarray[1]
		@z = pointsarray[2]
		return self
	end
	
	def ==(otherPoint)
		return (@x == otherPoint.x && @y == otherPoint.y && @z == otherPoint.z)
	end
end