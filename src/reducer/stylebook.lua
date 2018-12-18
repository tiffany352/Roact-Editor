local Modules = script.Parent.Parent.Parent
local Rodux = require(Modules.Rodux)

return Rodux.createReducer({}, {
	loadStylebook = function(state, action)
		return {
			roact = action.roact,
			components = action.components,
			parent = action.parent,
		}
	end,
	setTree = function(state, action)
		return {
			roact = state.roact,
			components = state.components,
			parent = state.parent,
		}
	end,
})
