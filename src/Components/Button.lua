local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local function Button(props)
	local size = props.size
	local text = props.text
	local onClick = props.onClick

	return Roact.createElement("ImageButton", {
		LayoutOrder = props.LayoutOrder,
		Size = size,
		Position = props.position,
		BackgroundColor3 = Color3.fromRGB(212, 212, 212),
		BorderSizePixel = 0,
		AutoButtonColor = not props.disabled,

		[Roact.Event.Activated] = function()
			if not props.disabled then
				onClick()
			end
		end,
	}, {
		Label = Roact.createElement("TextLabel", {
			Font = Enum.Font.SourceSans,
			Text = text,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1.0,
			TextColor3 = props.disabled and Color3.fromRGB(128, 128, 128) or Color3.fromRGB(0, 0, 0),
			TextSize = 20,
		})
	})
end

return Button
