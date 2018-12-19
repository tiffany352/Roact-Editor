local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local createFragment = require(Modules.Roact.createFragment)

local Document = require(script.Parent.Document)
local Toolbar = require(script.Parent.Toolbar)
local Explorer = require(script.Parent.Explorer)
local Properties = require(script.Parent.Properties)

local function App(props)
	return createFragment({
		Document = Roact.createElement(Document),
		Toolbar = Roact.createElement(Toolbar),
		Explorer = Roact.createElement(Explorer),
		Properties = Roact.createElement(Properties),
	})
end

return App
