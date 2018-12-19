-- Given an array of instances to check, tries to determine if the
-- selection is a Roact sytlebook.
--
-- If it succeeds, it returns true, and an object of this format:
--
--    {
--        roact: ModuleScript, -- The Roact copy used by the stylebook
--        modules: ModuleScript[], -- The modules for the components in the stylebook
--    }
--
-- If it fails, it returns false and a user-friendly message
-- explaining why.

local resolvePath = require(script.Parent.resolvePath)

local function checkForStylebook(selection)
	if #selection == 0 then
		return false, "No stylebook selected"
	elseif #selection > 1 then
		return false, "Select one object only"
	end

	selection = selection[1]

	if not selection:IsA("ModuleScript") and not selection:IsA("Folder") then
		return false, "Select a folder or modulescript"
	end

	local components = {}
	local roact = nil
	for _,child in pairs(selection:GetChildren()) do
		if child:IsA("ModuleScript") then
			local ok, result = pcall(require, child)

			local isFunc = type(result) == 'function'
			local isComponent = type(result) == 'table' and rawget(result, 'render') ~= nil

			if ok and (isFunc or isComponent) then
				components[#components+1] = {
					name = type(result) == 'table' and tostring(result) or child.Name,
					component = result,
				}
			end

			if not roact then
				local source = child.Source

				local vars = {
					script = child,
				}
				for line in source:gmatch("[^\n\r]+") do
					local name, expression = line:match("^local (%w+) = (.+)$")
					if name and expression then
						if name == 'Roact' then
							local path = expression:match("^require%((.+)%)$")
							if path then
								roact = resolvePath(path, vars)
							end
							break
						else
							vars[expression] = resolvePath(expression, vars)
						end
					end
				end
			end
		end
	end

	if #components == 0 then
		return false, "No components found in selection"
	end

	if roact == nil then
		return false, "Couldn't find Roact location"
	end

	return true, {
		roact = require(roact),
		components = components,
		parent = selection,
	}
end

return checkForStylebook
