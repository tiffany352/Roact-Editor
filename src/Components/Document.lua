local CoreGui = game:GetService("CoreGui")

local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local function Document(props)
	return Roact.createElement(Roact.Portal, {
		target = CoreGui,
	}, {
		RoactEditorDocument = Roact.createElement("ScreenGui", {
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = 500,
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
			}),
			Background = Roact.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(124, 124, 124),
				BorderColor3 = Color3.fromRGB(64, 64, 64),
				BorderSizePixel = 100,
				Image = "http://www.roblox.com/asset/?id=2658309676",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, 48, 0, 48),
			})
		})
	})
end

return Document
