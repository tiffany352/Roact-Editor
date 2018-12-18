local Modules = script.Parent.Parent.Parent
local Rodux = require(Modules.Rodux)
local Cryo = require(Modules.Cryo)

local empty = {
	nextId = 2,
	list = {
		{
			id = 1,
			type = "<Root>",
			props = {},
		}
	},
}

return Rodux.createReducer(empty, {
	loadStylebook = function(state, action)
		return empty
	end,
	addNode = function(state, action)
		local node = {
			id = state.nextId,
			type = action.nodeType,
			props = action.props,
			parent = action.parent,
		}
		return {
			nextId = state.nextId + 1,
			list = Cryo.List.join(state.list, {node}),
		}
	end,
	deleteNode = function(state, action)
		return {
			nextId = state.nextId,
			list = Cryo.List.filter(state.list, function(node) return node.id ~= action.nodeId end),
		}
	end,
})
