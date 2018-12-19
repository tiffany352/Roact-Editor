local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local function Switch(props)
	local value = props.value
	local setValue = props.setValue

	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0, 48, 0, 20),
		BackgroundColor3 = Color3.fromRGB(192, 192, 255),
		BorderColor3 = Color3.fromRGB(160, 160, 200),
		AutoButtonColor = false,

		[Roact.Event.Activated] = function()
			setValue(not value)
		end,
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 1),
			PaddingRight = UDim.new(0, 1),
			PaddingTop = UDim.new(0, 1),
			PaddingBottom = UDim.new(0, 1),
		}),
		OnText = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1.0,
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(64, 64, 120),
			TextSize = 12,
			Text = "On",
		}),
		OffText = Roact.createElement("TextLabel", {
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1.0,
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(64, 64, 120),
			TextSize = 12,
			Text = "Off",
		}),
		Slider = Roact.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(value and 0.5 or 0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(120, 120, 160),
			BorderSizePixel = 0,
		})
	})
end

return Switch
