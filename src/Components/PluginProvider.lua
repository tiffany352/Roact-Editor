local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local PluginProvider = Roact.Component:extend("PluginProvider")

function PluginProvider:init()
	self._context[PluginProvider] = self.props.plugin or error("plugin must be passed as props to PluginProvider")
end

function PluginProvider:render()
	return Roact.oneChild(self.props[Roact.Children])
end

return PluginProvider
