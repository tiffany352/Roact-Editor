local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local Icons = require(Modules.Plugin.Utilities.FamFamFam)

local function Icon(props)
	local iconInfo = Icons.Lookup(props.iconName) or Icons.Lookup("computer_error")

	return Roact.createElement("ImageLabel", {
		LayoutOrder = props.LayoutOrder,
		Size = props.Size or UDim2.new(0, 16, 0, 16),
		BackgroundTransparency = props.BackgroundTransparency or 1.0,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Image = iconInfo.Image,
		ImageRectOffset = iconInfo.ImageRectOffset,
		ImageRectSize = iconInfo.ImageRectSize,
	})
end

return Icon
