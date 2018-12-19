local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local Cryo = require(Modules.Cryo)

local function PropertyItem(props)
	local indent = 10 * props.depth
	local text = props.text
	local selected = props.selected
	local selectedColor = Color3.fromRGB(196, 196, 238)

	return Roact.createElement("ImageButton", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 0.5,
		BackgroundColor3 = selected and selectedColor or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,

		[Roact.Event.Activated] = props.onClick,

		[Roact.Event.MouseButton2Click] = props.showMenu,
	}, Cryo.Dictionary.join(props[Roact.Children] or {}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, indent),
		}),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 4),
		}),
		Label = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1.0,
			LayoutOrder = 0,
			Size = UDim2.new(0, 150-indent, 1, 0),
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = text,
		})
	}))
end

return PropertyItem
