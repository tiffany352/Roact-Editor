local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local PluginGui = require(script.Parent.PluginGui)
local PropertyTree = require(script.PropertyTree)

local function Properties(props)
	return Roact.createElement(PluginGui, {
		plugin = props.plugin,
		Name = "RoactEditorProperties",
		Title = "Roact Properties",
		InitialDockState = Enum.InitialDockState.Right,
		InitialEnabled = true,
		OverrideRestore = true,
		MinSize = Vector2.new(200, 0),
	}, {
		render = function(toggleEnabled)
			toggleEnabled(true)
			return Roact.createElement("ImageButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1.0,
			}, {
				PropertyTree = Roact.createElement(PropertyTree),
			})
		end,
	})
end

return Properties
