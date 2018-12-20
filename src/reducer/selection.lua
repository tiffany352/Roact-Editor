local Modules = script.Parent.Parent.Parent
local Rodux = require(Modules.Rodux)
local Cryo = require(Modules.Cryo)

return Rodux.createReducer({}, {
	loadStylebook = function(state, action)
		-- clear
		return {}
	end,
	loadDocument = function(state, action)
		return {}
	end,
	setSelection = function(state, action)
		return action.selection
	end,
	selectNode = function(state, action)
		if Cryo.List.find(state, action.node) then
			return Cryo.List.removeValue(state, action.node)
		else
			return Cryo.List.join(state, { action.node })
		end
	end,
	deleteNode = function(state, action)
		return Cryo.List.removeValue(state, action.nodeId)
	end,
})
