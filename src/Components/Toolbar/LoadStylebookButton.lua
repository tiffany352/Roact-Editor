local Selection = game:GetService("Selection")

local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local loadStylebook = require(Modules.Plugin.Actions.loadStylebook)
local Button = require(Modules.Plugin.Components.Button)
local checkForStylebook = require(Modules.Plugin.Utilities.checkForStylebook)

local LoadStylebookButton = Roact.Component:extend("LoadStylebookButton")

function LoadStylebookButton:init()
	self.state = {
		selection = Selection:Get(),
	}
	self.selectionConn = Selection.SelectionChanged:Connect(function()
		self:setState({
			selection = Selection:Get(),
		})
	end)
end

function LoadStylebookButton:willUnmount()
	self.selectionConn:Disconnect()
end

function LoadStylebookButton:render()
	local text = "Load Stylebook:\n"
	local disabled = false
	local result

	if self.props.stylebook then
		text = "Unload Stylebook"
	else
		local hasStylebook
		hasStylebook, result = checkForStylebook(self.state.selection)

		if not hasStylebook then
			text = text .. result
			disabled = true
		else
			text = text .. string.format("%d components", #result.components)
		end
	end

	return Roact.createElement(Button, {
		LayoutOrder = self.props.LayoutOrder,
		size = UDim2.new(1, 0, 0, 48),
		text = text,
		disabled = disabled,
		onClick = function()
			if result then
				self.props.loadStylebook(result.roact, result.components, result.parent)
			else
				self.props.loadStylebook()
			end
		end,
	})
end

local function mapStateToProps(state)
	return {
		stylebook = state.stylebook.parent and state.stylebook.parent.Name,
	}
end

local function mapDispatchToProps(dispatch)
	return {
		loadStylebook = function(roact, components, parent)
			dispatch(loadStylebook(roact, components, parent))
		end,
	}
end

LoadStylebookButton = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(LoadStylebookButton)

return LoadStylebookButton
