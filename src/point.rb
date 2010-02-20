class Point
	attr_accessor :x, :y, :z, :branch
	
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
	
	def as_array
		return [@x, @y, @z]
	end
end