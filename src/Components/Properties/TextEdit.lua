local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local function TextEdit(props)
	local value = props.value
	local setValue = props.setValue

	return Roact.createElement("TextBox", {
		LayoutOrder = 2,
		Text = tostring(value),
		Size = UDim2.new(1, -150, 0, 22),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(238, 238, 238),
		Font = Enum.Font.SourceSans,
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,

		[Roact.Event.FocusLost] = function(rbx, enterPressed)
			if enterPressed then
				local text = rbx.Text
				rbx.Text = tostring(value)
				setValue(text)
			end
		end,
	})
end

return TextEdit
