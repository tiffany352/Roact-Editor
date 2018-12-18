local TextService = game:GetService("TextService")

local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local function ComponentWrapperError(props)
	local text = props.error
	local font = Enum.Font.SourceSansBold
	local textSize = 20

	local bounds = TextService:GetTextSize(text, textSize, font, Vector2.new(0, 0))

	return Roact.createElement("Frame", {
		Size = props.Size or UDim2.new(1, 0, 1, 0),
		Position = props.Size or UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		BorderColor3 = Color3.fromRGB(96, 0, 0),
	}, {
		ErrorText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1.0,
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextWrapped = true,
			Font = font,
			TextSize = textSize,
			Text = text,
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(bounds.x, math.huge),
			})
		})
	})
end

return ComponentWrapperError
