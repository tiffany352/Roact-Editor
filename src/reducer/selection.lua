local Modules = script.Parent.Parent.Parent
local Rodux = require(Modules.Rodux)

return Rodux.createReducer({}, {
	setSelection = function(state, action)
		return action.selection
	end,
	selectNode = function(state, action)
		local newSelection = {}
		local alreadyContains = false

		for i = 1, #state do
			if state[i] == action.node then
				alreadyContains = true
			else
				newSelection[#newSelection + 1] = state[i]
			end
		end

		if not alreadyContains then
			newSelection[#newSelection + 1] = action.node
		end

		return newSelection
	end,
})
