local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local Cryo = require(Modules.Cryo)
local setSelection = require(Modules.Plugin.Actions.setSelection)
local deleteNode = require(Modules.Plugin.Actions.deleteNode)
local reifyTree = require(Modules.Plugin.Utilities.reifyTree)

local PluginGui = require(script.Parent.PluginGui)
local PluginAccessor = require(script.Parent.PluginAccessor)
local ExplorerNode = require(script.ExplorerNode)

local function Explorer(props)
	return PluginAccessor.withPlugin(function(plugin)
		local children = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			})
		}

		local function recurseNode(treeNode, depth)
			local node = treeNode.node
			local selected = Cryo.List.find(props.selection, node.id)

			children[#children+1] = Roact.createElement(ExplorerNode, {
				LayoutOrder = #children,
				depth = depth,
				node = node,
				selected = selected,

				onClick = function()
					props.selectItem(node.id)
				end,

				showMenu = function()
					local menu = plugin:createPluginMenu("RoactExplorerMenu", node.type, "")
					local actionDelete = menu:AddNewAction("Delete", "Delete", "")
					local result = menu:ShowAsync()
					if result == actionDelete then
						props.deleteNode(node.id)
					end
					menu:Destroy()
				end,
			})

			for _,child in pairs(treeNode.children or {}) do
				recurseNode(child, depth + 1)
			end
		end

		if props.tree then
			for _,child in pairs(props.tree.children or {}) do
				recurseNode(child, 0)
			end
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
	end)
end

local function mapStateToProps(state)
	local tree = reifyTree(state.nodes.list, 1)

	return {
		tree = tree,
		selection = state.selection,
	}
end

local function mapDispatchToProps(dispatch)
	return {
		selectItem = function(node)
			dispatch(setSelection({node}))
		end,
		deleteNode = function(node)
			dispatch(deleteNode(node))
		end,
	}
end

Explorer = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(Explorer)

return Explorer
