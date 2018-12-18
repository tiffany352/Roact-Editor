local function deleteNode(nodeId)
	return {
		type = "deleteNode",
		nodeId = nodeId,
	}
end

return deleteNode
