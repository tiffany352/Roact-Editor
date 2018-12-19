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
		-- Trim out orphaned nodes.
		local isDescendant = {}
		for _,node in pairs(state.list) do
			if node.parent == action.nodeId or isDescendant[node.parent] then
				isDescendant[node.id] = true
			end
		end

		return {
			nextId = state.nextId,
			list = Cryo.List.filterMap(state.list, function(node)
				if node.id == action.nodeId or isDescendant[node.id] then
					return nil
				end
				return node
			end),
		}
	end,
	setProp = function(state, action)
		return {
			nextId = state.nextId,
			list = Cryo.List.map(state.list, function(node)
				if node.id == action.nodeId then
					return Cryo.Dictionary.join(node, {
						props = Cryo.Dictionary.join(node.props, {
							[action.propName] = action.propValue,
						})
					})
				end
				return node
			end)
		}
	end,
})
