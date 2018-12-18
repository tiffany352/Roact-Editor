local Modules = script.Parent
local Roact = require(Modules.Roact)
local Rodux = require(Modules.Rodux)
local RoactRodux = require(Modules.RoactRodux)

local App = require(script.Components.App)
local PluginProvider = require(script.Components.PluginProvider)
local reducer = require(script.reducer)

return function(plugin, savedState)
	local store = Rodux.Store.new(reducer, savedState)

	local element = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		PluginProvider = Roact.createElement(PluginProvider, {
			plugin = plugin,
		}, {
			App = Roact.createElement(App)
		})
	})

	local handle = Roact.mount(element)

	plugin:beforeUnload(function()
		Roact.unmount(handle)

		return store:getState()
	end)
end
