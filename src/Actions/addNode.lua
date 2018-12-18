local function addNode(type, props, parent)
	return {
		type = "addNode",
		nodeType = type,
		props = props,
		parent = parent,
	}
end

return addNode
