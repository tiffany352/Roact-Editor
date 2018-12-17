local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local createFragment = require(Modules.Roact.createFragment)

local Document = require(script.Parent.Document)
local Toolbar = require(script.Parent.Toolbar)

local function App(props)
	local plugin = props.plugin

	return createFragment({
		Document = Roact.createElement(Document),
		Toolbar = Roact.createElement(Toolbar, {
			plugin = plugin,
		})
	})
end

return App