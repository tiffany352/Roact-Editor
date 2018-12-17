local Modules = script.Parent
local Roact = require(Modules.Roact)

local App = require(script.Components.App)

return function(plugin, savedState)
	local element = Roact.createElement(App, {
		plugin = plugin,
	})

	local handle = Roact.mount(element)

	plugin:beforeUnload(function()
		Roact.unmount(handle)

		return nil
	end)
end
