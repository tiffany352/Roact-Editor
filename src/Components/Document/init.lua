local CoreGui = game:GetService("CoreGui")

local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local DocumentNode = require(script.DocumentNode)

local Document = Roact.Component:extend("Document")

function Document:init()
	self.state = {
		zoomLevel = 1,
		pan = Vector2.new(0.5, 0.5),
	}
end

function Document:mousePanBy(rbx, x, y)
	local delta = Vector2.new(x, y) - self.startPos
	local relativeDelta = delta / rbx.AbsoluteSize / self.state.zoomLevel
	local newPan = Vector2.new(
		math.clamp(self.state.pan.X + relativeDelta.X, 0, 1),
		math.clamp(self.state.pan.Y + relativeDelta.Y, 0, 1)
	)
	self.startPos = Vector2.new(x, y)
	self:setState({
		pan = newPan,
	})
end

function Document:render()
	local props = self.props

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
			Fill = Roact.createElement("ImageButton", {
				ZIndex = -1,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(64, 64, 64),
				BorderColor3 = Color3.fromRGB(64, 64, 64),
				BorderSizePixel = 100,
				AutoButtonColor = false,

				[Roact.Event.MouseButton1Down] = function(rbx, x, y)
					self.panning = true
					self.startPos = Vector2.new(x, y)
				end,
				[Roact.Event.MouseButton1Up] = function(rbx, x, y)
					self.panning = false
					self:mousePanBy(rbx, x, y)
				end,
				[Roact.Event.MouseMoved] = function(rbx, x, y)
					if self.panning then
						self:mousePanBy(rbx, x, y)
					end
				end,

				[Roact.Event.MouseWheelForward] = function(rbx)
					self:setState({
						zoomLevel = self.state.zoomLevel * 1.2,
					})
				end,

				[Roact.Event.MouseWheelBackward] = function(rbx)
					self:setState({
						zoomLevel = self.state.zoomLevel / 1.2,
					})
				end,
			}),
			Background = Roact.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(1, 1) - self.state.pan,
				BackgroundColor3 = Color3.fromRGB(124, 124, 124),
				BorderColor3 = Color3.fromRGB(64, 64, 64),
				BorderSizePixel = 0,
				Image = "http://www.roblox.com/asset/?id=2658309676",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.new(0, 48, 0, 48),
			}, {
				UIScale = Roact.createElement("UIScale", {
					Scale = self.state.zoomLevel,
				}),
				RootNode = Roact.createElement(DocumentNode, {
					tree = props.tree,
					innerRoact = props.roact,
				})
			})
		})
	})
end

local function mapStateToProps(state)
	return {
		tree = state.stylebook.tree or {},
		roact = state.stylebook.roact,
	}
end

Document = RoactRodux.connect(mapStateToProps)(Document)

return Document
