#!/usr/bin/env lua

local function pwrapper(process)
	local file = assert(io.popen(process))
	local output = file:read("*all")
	file:close()
	return output
end


local function branch(branchname)
	pwrapper('git branch -av')
	if branchname then
		local output = pwrapper('git checkout '..branchname)
		if output:sub(1,5) == "error" then
			print("Branch '"..branchname"' not found, would you like to create it? ([y]/n):")
			local answer = io.read()
			if answer ~= "n" and answer ~= "N" then
				print(pwrapper('git checkout -b '..branchname))
			end
		end
	else
		print("Enter the name of the branch you'd like to switch to, or enter a new name to create a new branch:")
		branchname = io.read()
		local output = pwrapper('git checkout '..branchname)
	end
end

local function clone(url)
	print(pwrapper('git clone', url))
end

local function init()
	print(pwrapper('git init'))
end

if arg[1] == "branch" then
	branch(arg[2])
elseif arg[1] == "init" then
	init()
end
