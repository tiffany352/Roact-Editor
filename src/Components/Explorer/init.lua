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

local Explorer = Roact.Component:extend("Explorer")

function Explorer:render()
	local props = self.props

	local dragging = self.state.dragging
	local pluginGuiRef = {
		current = nil
	}

	return PluginAccessor.withPlugin(function(plugin)
		local children = {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		}

		local function recurseNode(treeNode, depth)
			local node = treeNode.node
			local selected = Cryo.List.find(props.selection, node.id)

			local index = #children + 1

			local isDragging = dragging and dragging.currentIndex ~= dragging.startIndex

			if isDragging and dragging.currentIndex == index then
				children.Dragging = Roact.createElement(ExplorerNode, {
					LayoutOrder = index * 2 - 1,
					depth = depth,
					node = Cryo.List.filter(props.nodes, function(entry) return entry.id == dragging.nodeId end)[1],
					selected = true,
				})
			end

			if not isDragging or dragging.nodeId ~= node.id then
				children[index] = Roact.createElement(ExplorerNode, {
					-- Multiply by two to leave room for the dragged element.
					LayoutOrder = index * 2,
					depth = depth,
					node = node,
					selected = selected,

					onClick = function()
						props.selectItem(node.id)
					end,

					mouseDown = function()
						props.selectItem(node.id)

						self:setState({
							dragging = {
								nodeId = node.id,
								startIndex = index,
								currentIndex = index,
							}
						})
						while self.state.dragging do
							if pluginGuiRef.current then
								local mousePos = pluginGuiRef.current:GetRelativeMousePosition()
								local itemHeight = 18
								local newIndex = math.floor(mousePos.Y / itemHeight) + 1
								if newIndex ~= self.state.currentIndex then
									self:setState({
										dragging = {
											nodeId = node.id,
											startIndex = index,
											currentIndex = newIndex,
										}
									})
								end
							end
							wait()
						end
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
			end

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
			render = function(toggleEnabled, pluginGui)
				pluginGuiRef.current = pluginGui
				toggleEnabled(true)
				return Roact.createElement("Folder", {}, {
					InputCapture = self.state.dragging and Roact.createElement("ImageButton", {
						Size = UDim2.new(1, 0, 1, 0),
						ZIndex = 100,
						BackgroundTransparency = 1.0,

						[Roact.Event.MouseButton1Up] = function()
							self:setState({
								dragging = Roact.None,
							})
						end,
					}),
					Contents = Roact.createElement("ImageButton", {
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1.0,

						[Roact.Event.Activated] = function()
							props.selectItem(nil)
						end,
					}, children)
				})
			end,
		})
	end)
end

local function mapStateToProps(state)
	local tree = reifyTree(state.nodes.list, 1)

	return {
		nodes = state.nodes.list,
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
