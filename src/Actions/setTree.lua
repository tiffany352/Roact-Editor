local function setTree(name, component)
	return {
		type = 'setTree',
		tree = {
			name = name,
			component = component,
			props = {},
			children = {},
		}
	}
end

return setTree
