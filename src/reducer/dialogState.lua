local Modules = script.Parent.Parent.Parent
local Rodux = require(Modules.Rodux)

local State = {
	None = "None",
	Load = "Load",
}

return Rodux.createReducer(State.None, {
	promptDialog = function(state, action)
		return action.dialogName
	end,
	loadDocument = function(state, action)
		return State.None
	end,
	closePrompt = function(state, action)
		return State.None
	end,
})
