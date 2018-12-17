local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)

local PluginGui = require(script.Parent.PluginGui)
local LoadStylebookButton = require(script.LoadStylebookButton)

local function Toolbar(props)
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
			}, {
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
			})
		end,
	})
end

local function mapStateToProps(state)
	return {
		stylebook = state.stylebook.parent and state.stylebook.parent.Name,
	}
end

Toolbar = RoactRodux.connect(mapStateToProps)(Toolbar)

return Toolbar
