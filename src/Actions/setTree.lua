local function setTree(component)
	return {
		type = 'setTree',
		tree = {
			component = component,
			props = {},
			children = {},
		}
	}
end

return setTree
