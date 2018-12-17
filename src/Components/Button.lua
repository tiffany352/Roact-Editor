local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local function Button(props)
	local size = props.size
	local text = props.text
	local onClick = props.onClick

	return Roact.createElement("ImageButton", {
		LayoutOrder = props.LayoutOrder,
		Size = size,
		BackgroundColor3 = Color3.fromRGB(212, 212, 212),
		BorderSizePixel = 0,

		[Roact.Event.Activated] = function()
			onClick()
		end,
	}, {
		Label = Roact.createElement("TextLabel", {
			Font = Enum.Font.SourceSans,
			Text = text,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1.0,
			TextSize = 20,
		})
	})
end

return Button
