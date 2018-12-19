local function setProp(nodeId, propName, propValue)
	return {
		type = "setProp",
		nodeId = nodeId,
		propName = propName,
		propValue = propValue,
	}
end

return setProp
