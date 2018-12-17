local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local createFragment = require(Modules.Roact.createFragment)

local Document = require(script.Parent.Document)
local Toolbar = require(script.Parent.Toolbar)

local function App(props)
	local plugin = props.plugin
	local state = props.state
	local updateState = props.updateState

	return createFragment({
		Document = Roact.createElement(Document, {
			state = state,
			updateState = updateState,
		}),
		Toolbar = Roact.createElement(Toolbar, {
			plugin = plugin,
			state = state,
			updateState = updateState,
		})
	})
end

return App
