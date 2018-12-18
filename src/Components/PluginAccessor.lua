local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local PluginProvider = require(script.Parent.PluginProvider)

local PluginAccessor = Roact.Component:extend("PluginAccessor")

function PluginAccessor:render()
	local render = Roact.oneChild(self.props[Roact.Children])

	local plugin = self._context[PluginProvider]
	assert(plugin, "PluginProvider must be ancestor of PluginAccessor")

	return render(plugin)
end

function PluginAccessor.withPlugin(func)
	return Roact.createElement(PluginAccessor, {}, {func})
end

return PluginAccessor
