# build targets for ruby-tree-grow




# Default task just displays usage information
task :default do
	puts "Rake targets:"
	puts "  Run program using 'rake run'"
	puts "  Run all tests using 'rake test'"
	puts "  Run specific test using the name of the test, e.g. 'rake test_point'"
end


# Set the $LOAD_PATH variable to include all the source files
task :addSourceFiles do
	$LOAD_PATH.push File.dirname(__FILE__) + "/src/"
end


# Set the $LOAD_PATH variable to include all the test files
task :addTestFiles do
	$LOAD_PATH.push File.dirname(__FILE__) + "/test/"
end



# Run the actual program
task :run => :addSourceFiles do
	require 'tree_grower'
end


# Target to run the entire test suite
task :test => [:addSourceFiles, :addTestFiles] do
	require 'test_suite'
end


# In Rakefile: create a target for each of the 'test_*' files 
# in the test folder, so they can be called individually
Dir['test/test*.rb'].each { |test_case| 
	test_case_name = test_case.sub(/^test\//, "").sub(/\.rb$/, "")
	# DEBUG puts "Adding test task: " + test_case_name
	task test_case_name => [:addSourceFiles, :addTestFiles] do
		require File.dirname(__FILE__) + "/" + test_case
	end
}