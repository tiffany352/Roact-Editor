local Modules = script.Parent.Parent
local Rodux = require(Modules.Rodux)

return Rodux.combineReducers({
	stylebook = require(script.stylebook),
	editorEnabled = require(script.editorEnabled),
})
