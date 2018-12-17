local Modules = script.Parent.Parent.Parent
local Rodux = require(Modules.Rodux)

return Rodux.createReducer({}, {
	loadStylebook = function(state, action)
		return {
			roact = action.roact,
			modules = action.modules,
			parent = action.parent,
			tree = {},
		}
	end
})
