local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local PluginGui = require(script.Parent.PluginGui)

local function Dialog(props)
	return Roact.createElement(PluginGui, {
		Name = props.name,
		Title = props.title,
		InitialDockState = Enum.InitialDockState.Float,
		InitialEnabled = false,
		OverrideRestore = true,
		FloatingSize = props.size,
		MinSize = props.size,

		onClosed = props.onClosed,
		alwaysOpen = true,
	}, {
		render = function(toggleEnabled)
			toggleEnabled(true)
			return Roact.createElement("Folder", {}, props[Roact.Children])
		end,
	})
end

return Dialog
