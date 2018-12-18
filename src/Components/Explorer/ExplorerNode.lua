local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local Icon = require(Modules.Plugin.Components.Icon)

local function ExplorerNode(props)
	local indent = 10 * props.depth
	local node = props.node
	local selectedColor = Color3.fromRGB(96, 96, 238)

	return Roact.createElement("ImageButton", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 0.5,
		BackgroundColor3 = props.selected and selectedColor or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,

		[Roact.Event.Activated] = props.onClick,

		[Roact.Event.MouseButton2Click] = props.showMenu,
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, indent),
		}),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 4),
		}),
		Icon = Roact.createElement(Icon, {
			LayoutOrder = 1,
			iconName = "folder",
		}),
		Label = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1.0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, indent, 0, 0),
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = node.type,
		})
	})
end

return ExplorerNode
