local function loadStylebook(roact, modules, parent)
	return {
		type = "loadStylebook",
		roact = roact,
		modules = modules,
		parent = parent,
	}
end

return loadStylebook
