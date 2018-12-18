local function loadStylebook(roact, components, parent)
	return {
		type = "loadStylebook",
		roact = roact,
		components = components,
		parent = parent,
	}
end

return loadStylebook
