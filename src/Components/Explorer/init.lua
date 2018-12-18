local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local setTree = require(Modules.Plugin.Actions.setTree)
local setSelection = require(Modules.Plugin.Actions.setSelection)

local PluginGui = require(script.Parent.PluginGui)
local ExplorerNode = require(script.ExplorerNode)

local function Explorer(props)
	local children = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	}

	local function recurseNode(node, depth)
		local selected = false
		for _,item in pairs(props.selection or {}) do
			if node == item then
				selected = true
			end
		end

		children[#children+1] = Roact.createElement(ExplorerNode, {
			LayoutOrder = #children,
			depth = depth,
			node = node,
			selected = selected,

			onClick = function()
				props.selectItem(node)
			end,
		})

		for _,child in pairs(node.children or {}) do
			recurseNode(children, child, depth + 1)
		end
	end

	if props.tree then
		recurseNode(props.tree, 0)
	end

	return Roact.createElement(PluginGui, {
		plugin = props.plugin,
		Name = "RoactEditorExplorer",
		Title = "Roact Explorer",
		InitialDockState = Enum.InitialDockState.Right,
		InitialEnabled = true,
		OverrideRestore = true,
		MinSize = Vector2.new(200, 0),
	}, {
		render = function(toggleEnabled)
			return Roact.createElement("ImageButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1.0,

				[Roact.Event.Activated] = function()
					props.selectItem(nil)
				end,
			}, children)
		end,
	})
end

local function mapStateToProps(state)
	return {
		tree = state.stylebook.tree,
		selection = state.selection,
	}
end

local function mapDispatchToProps(dispatch)
	return {
		setTree = function(component)
			dispatch(setTree(component))
		end,
		selectItem = function(node)
			dispatch(setSelection({node}))
		end,
	}
end

Explorer = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(Explorer)

return Explorer
