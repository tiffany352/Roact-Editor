local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local PluginGui = require(script.Parent.PluginGui)

function Toolbar(props)
	return Roact.createElement(PluginGui, {
		plugin = props.plugin,
		Name = "RoactEditorToolbar",
		Title = "Roact Editor",
		InitialDockState = Enum.InitialDockState.Left,
		InitialEnabled = true,
		OverrideRestore = true,
		MinSize = Vector2.new(200, 0),
	}, {
		render = function(toggleEnabled)
			return Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1.0,
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
					PaddingTop = UDim.new(0, 4),
					PaddingBottom = UDim.new(0, 4),
				}),
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4),
				}),
				Button = Roact.createElement("ImageButton", {
					Size = UDim2.new(1, 0, 0, 36),
					BackgroundColor3 = Color3.fromRGB(212, 212, 212),
					BorderSizePixel = 0,
				}, {
					Label = Roact.createElement("TextLabel", {
						Font = Enum.Font.SourceSans,
						Text = "A Button",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1.0,
						TextSize = 24,
					})
				}),
			})
		end,
	})
end

return Toolbar
