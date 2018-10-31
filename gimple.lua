#!/usr/bin/env lua

--[TODO: Reversions, Tab completion, catch ctrl-C, more operations, init when needed, documentation, luarocks]


local function pwrapper(process)
	-- redirect stderr to stdout, else we can't read it
	local handle = io.popen(process.." 2>&1")
	local output = handle:read("*all")
	handle:close()
	return output
end


local function branch(branchname)
	if branchname then
		local output = pwrapper('git checkout '..branchname)
		if output:sub(1,5) == "error" then
			print(pwrapper('git branch -av'))
			print("Branch '"..branchname.."' not found, would you like to create it? ([y]/n):")
			local answer = io.read()
			if answer ~= "n" and answer ~= "N" then
				print(pwrapper('git checkout -b '..branchname))
			end
		end
	else
		print(pwrapper('git branch -av'))
		print("Enter the name of the branch you'd like to switch to, or enter a new name to create a new branch and switch to it:")
		branchname = io.read()
		local output = pwrapper('git checkout '..branchname)
		if output:sub(1,5) == "error" then
			print(pwrapper('git checkout -b'..branchname))
		end
	end
end

local function commit()
	print(pwrapper('git status -s'))
	print("Enter a commit message to add all untracked files and commit all changes (ctrl-c to cancel):")
	message = io.read()
	print(pwrapper('git add *'))
	print(pwrapper('git commit -m "'..message..'"'))
end

local function clone(url)
	if not url then
		print("Enter the URL you'd like to clone:")
		url = io.read()
	end
	print(pwrapper('git clone "'..url))
end

local function init()
	print(pwrapper('git init'))
end

local function revert(commitNo)
	if not commitNo then
		print(pwrapper('git log -n 5'))
		print("Enter the commit no. you'd like to revert to:")
		print("(Your work will be backed up) Ctrl-C to cancel.")
		commitNo = io.read()
	end
	local backupNo = --TODO
	pwrapper('git branch gimplebackup'..backupNo)
end

if arg[1] == "branch" then
	branch(arg[2])
elseif arg[1] == "commit" then
	commit()
elseif arg[1] == "clone" then
	clone(arg[2])
elseif arg[1] == "init" then
	init()
end
