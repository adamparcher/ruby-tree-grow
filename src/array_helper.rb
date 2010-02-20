
# Need a new method to add two arrays together element-by-element
# TODO: unit tests for this
class Array
	def math_add(otherArray)
		result = self.clone
		(0..self.size-1).each { |i|
			result[i] = result[i] + otherArray[i]
		}
		return result
	end
end