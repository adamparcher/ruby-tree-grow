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
	 
	 def calculateLines
		#DEBUG puts "calculateLines"
		vertices = []
		pPrev = nil
		@points.each { |p|
			#DEBUG puts "current point: " + p.to_yaml
			if pPrev.nil? then  # if this is the first point
				#DEBUG puts "first point, moving on to next one..."
				pPrev = p # just record the point and go to the next one
				# FIXME: Possible bug, what if the first point has a branch? Can that happen?
			else
				# First add the line segment to the current point
				vertices.push pPrev.as_array 
				vertices.push p.as_array
				#DEBUG puts "after adding segment for current point, vertices: " ; vertices.each do |v| puts "  " + v*"," end
				# THen if there is a branch attached, go down it recursively
				if !p.branch.nil? then
					#DEBUG puts "point has a branch"
					branchVerts = p.branch.calculateLines # first get the branch's vertices
					#DEBUG puts "before adding, branch verts: " ; branchVerts.each do |v| puts "  " + v*"," end
					combinedVerts = []
					branchVerts.each { |v|
						combinedVerts.push v.math_add(p.as_array) # Add the current point's coordinate values
					}
					#DEBUG puts "after adding, branch verts: " ; combinedVerts.each do |v| puts "  " + v*"," end
					vertices += combinedVerts
				end
				
				pPrev = p
			end  
			#DEBUG puts "right now vertices is: " ; vertices.each do |v| puts "  " + v*"," end
		}
		return vertices
	 end
	 
end
