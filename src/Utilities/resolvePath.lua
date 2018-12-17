-- Given a Lua-like path string (e.g. script.Parent.SomeObj), and a
-- starting point, return the resulting instance.

local function resolvePathInner(path, currentNode)
	local first, rest = path:match("^([^%.]+)%.(.*)$")
	if not first then
		first = path:match("^([^%.]+)$")
	end

	local nextNode
	if first == 'Parent' then
		nextNode = currentNode.Parent
	else
		nextNode = currentNode:FindFirstChild(first)
	end

	if rest and nextNode then
		return resolvePathInner(rest, nextNode)
	else
		return nextNode
	end
end

local function resolvePath(path, vars)
	local first, rest = path:match("^([^%.]+)%.(.*)$")

	if vars[first] then
		return resolvePathInner(rest, vars[first])
	end

	return nil
end

return resolvePath
