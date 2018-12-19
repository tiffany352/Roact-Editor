local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local PluginAccessor = require(Modules.Plugin.Components.PluginAccessor)

local function Dropdown(props)
	if typeof(props.value) ~= 'EnumItem' then
		return nil
	end

	local value = props.value
	local enumType = value.EnumType
	local setValue = props.setValue

	return PluginAccessor.withPlugin(function(plugin)
		return Roact.createElement("TextButton", {
			LayoutOrder = 2,
			Text = typeof(value) == 'EnumItem' and value.Name or '',
			Size = UDim2.new(1, -150, 0, 22),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(238, 238, 238),
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,

			[Roact.Event.Activated] = function(rbx)
				local menu = plugin:createPluginMenu("Dropdown", "Dropdown", "")

				local actions = {}
				for _, item in pairs(enumType:GetEnumItems()) do
					local action = menu:AddNewAction(item.Name, item.Name, "")
					actions[action] = item
				end

				local result = menu:ShowAsync()
				if result then
					local newValue = actions[result]
					setValue(newValue)
				end

				menu:Destroy()
			end,
		})
	end)
end

return Dropdown
