local Source = script.Parent.Parent.Parent
local Roact = require(Source.Roact)

local PluginAccessor = require(script.Parent.PluginAccessor)

local PluginGuiView = Roact.PureComponent:extend("PluginGuiView")

--[[
	props: {
		plugin: object,
		Name: string,
		Title: string,
		InitialDockState: InitialDockState,
		InitialEnabled: boolean = false,
		OverrideRestore: boolean = false,
		FloatingSize: Vector2 = Vector2.new(0, 0),
		MinSize: Vector2 = Vector2.new(0, 0),
	}
]]

function PluginGuiView:init()
	local props = self.props

	coroutine.wrap(function()
		local info = DockWidgetPluginGuiInfo.new(
			props.InitialDockState,
			props.InitialEnabled or false,
			props.OverrideRestore or false,
			props.FloatingSize and props.FloatingSize.X or 0,
			props.FloatingSize and props.FloatingSize.Y or 0,
			props.MinSize and props.MinSize.X or 0,
			props.MinSize and props.MinSize.Y or 0
		)
		local pluginGui = props.plugin:createDockWidgetPluginGui(props.Name, info)
		pluginGui.Name = props.Name
		pluginGui.Title = props.Title
		pluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		if props.alwaysOpen then
			pluginGui.Enabled = true
		end

		pluginGui:BindToClose(function()
			if props.onClosed then
				props.onClosed()
			else
				pluginGui.Enabled = false
			end
		end)

		self.pluginGui = pluginGui

		self.toggleEnabled = function(value)
			if value ~= nil then
				pluginGui.Enabled = value
			else
				pluginGui.Enabled = not pluginGui.Enabled
			end
		end
	end)()
end

function PluginGuiView:willUnmount()
	if self.props.alwaysOpen then
		self.pluginGui.Enabled = false
	end
end

function PluginGuiView:render()
	if self.pluginGui then
		self.pluginGui.Name = self.props.Name
		self.pluginGui.Title = self.props.Title
		local render = Roact.oneChild(self.props[Roact.Children])
		return Roact.createElement(Roact.Portal, {
			target = self.pluginGui,
		}, {
			[self.props.Name] = render(self.toggleEnabled, self.pluginGui)
		})
	else
		return nil
	end
end

local function PluginGui(props)
	return PluginAccessor.withPlugin(function(plugin)
		return Roact.createElement(PluginGuiView, {
			plugin = plugin,
			Name = props.Name,
			Title = props.Title,
			InitialDockState = props.InitialDockState,
			InitialEnabled = props.InitialEnabled,
			OverrideRestore = props.OverrideRestore,
			FloatingSize = props.FloatingSize,
			MinSize = props.MinSize,
			onClosed = props.onClosed,
			alwaysOpen = props.alwaysOpen,
		}, props[Roact.Children])
	end)
end

return PluginGui
