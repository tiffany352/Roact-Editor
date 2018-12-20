local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local createFragment = require(Modules.Roact.createFragment)

local Document = require(script.Parent.Document)
local Toolbar = require(script.Parent.Toolbar)
local Explorer = require(script.Parent.Explorer)
local Properties = require(script.Parent.Properties)
local LoadDialog = require(script.Parent.LoadDialog)
local SaveDialog = require(script.Parent.SaveDialog)

local function App(props)
	return createFragment({
		Document = Roact.createElement(Document),
		Toolbar = Roact.createElement(Toolbar),
		Explorer = Roact.createElement(Explorer),
		Properties = Roact.createElement(Properties),

		LoadDialog = Roact.createElement(LoadDialog),
		SaveDialog = Roact.createElement(SaveDialog),
	})
end

return App
