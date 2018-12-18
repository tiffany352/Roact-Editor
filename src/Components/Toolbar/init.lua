local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local addNode = require(Modules.Plugin.Actions.addNode)

local PluginGui = require(script.Parent.PluginGui)
local Button = require(script.Parent.Button)
local LoadStylebookButton = require(script.LoadStylebookButton)

local function Toolbar(props)
	local children = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
		}),
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		}),
		CurrentStylebook = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1.0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, props.stylebook and 44 or 24),
			Font = Enum.Font.SourceSans,
			TextSize = 20,
			Text = props.stylebook and string.format("Current Stylebook:\n%s", props.stylebook) or "No stylebook loaded.",
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		LoadStylebook = Roact.createElement(LoadStylebookButton, {
			LayoutOrder = 2,
		}),
	}

	local index = 3
	for _,component in pairs(props.components or {}) do
		children[component.name] = Roact.createElement(Button, {
			LayoutOrder = index,
			size = UDim2.new(1, 0, 0, 22),
			text = component.name,
			onClick = function()
				props.addNode(component.name, {}, props.parentSelected)
			end,
		})
		index = index + 1
	end

	return Roact.createElement(PluginGui, {
		plugin = props.plugin,
		Name = "RoactEditorToolbar",
		Title = "Roact Editor",
		InitialDockState = Enum.InitialDockState.Left,
		InitialEnabled = true,
		OverrideRestore = true,
		MinSize = Vector2.new(200, 0),
	}, {
		render = function(toggleEnabled)
			return Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1.0,
			}, children)
		end,
	})
end

local function mapStateToProps(state)
	local parentSelected = 1
	if #state.selection == 1 then
		parentSelected = state.selection[1]
	end

	return {
		stylebook = state.stylebook.parent and state.stylebook.parent.Name,
		components = state.stylebook.components,
		parentSelected = parentSelected,
	}
end

local function mapDispatchToProps(dispatch)
	return {
		addNode = function(type, props, parent)
			dispatch(addNode(type, props, parent))
		end
	}
end

Toolbar = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(Toolbar)

return Toolbar
