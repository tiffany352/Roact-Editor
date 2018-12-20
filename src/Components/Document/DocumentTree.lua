local Modules = script.Parent.Parent.Parent.Parent
local Cryo = require(Modules.Cryo)
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local createComponentWrapper = require(Modules.Plugin.Components.createComponentWrapper)
local reifyTree = require(Modules.Plugin.Utilities.reifyTree)

local DocumentTree = Roact.Component:extend("DocumentTree")

function DocumentTree.getDerivedStateFromProps(props, lastState)
	if props.childRoact ~= lastState.childRoact then
		return {
			childRoact = props.childRoact,
			componentWrapper = props.childRoact and createComponentWrapper(Roact, props.childRoact),
		}
	end
end

function DocumentTree:render()
	local props = self.props
	local ChildRoact = props.childRoact
	local Wrapper = self.state.componentWrapper

	if not ChildRoact then
		return Roact.createElement("Folder", {}, {
			Message = Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 300, 0, 150),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Font = Enum.Font.SourceSansBold,
				TextSize = 20,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundColor3 = Color3.fromRGB(96, 96, 96),
				BorderColor3 = Color3.fromRGB(48, 48, 48),
				Text = "No stylebook loaded",
			})
		})
	end

	local function recurseNode(treeNode)
		local children = {}
		for i = 1, #treeNode.children do
			local child = treeNode.children[i]
			children[child.node.type..child.node.id] = recurseNode(child)
		end

		local node = treeNode.node
		local newProps = Cryo.Dictionary.join(node.props, {})
		return ChildRoact.createElement(node.component or "Folder", newProps, children)
	end

	local element = recurseNode(props.tree)

	return Roact.createElement("Folder", {}, {
		[tostring(ChildRoact)] = Roact.createElement(Wrapper, {}, {
			Inner = element,
		}),
	})
end

local function mapStateToProps(state)
	local nodesWithComponents = Cryo.List.map(state.nodes.list, function(node)
		local entry = Cryo.List.filter(state.stylebook.components or {}, function(comp)
			return comp.name == node.type
		end)[1]
		return Cryo.Dictionary.join(node, {
			component = entry and entry.component or nil,
		})
	end)
	local tree = reifyTree(nodesWithComponents, 1)
	assert(tree)

	return {
		tree = tree,
		childRoact = state.stylebook.roact,
	}
end

DocumentTree = RoactRodux.connect(mapStateToProps)(DocumentTree)

return DocumentTree
