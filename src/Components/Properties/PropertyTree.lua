local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local Cryo = require(Modules.Cryo)

local PropertyItem = require(script.Parent.PropertyItem)

local function SectionItem(props)
	return Roact.createElement(PropertyItem, {
		LayoutOrder = props.LayoutOrder,
		text = props.sectionName,
		depth = props.depth,
	})
end

local function EditItem(props)
	return Roact.createElement(PropertyItem, {
		LayoutOrder = props.LayoutOrder,
		text = props.propertyName,
		depth = props.depth,
	}, {
		Edit = Roact.createElement("TextBox", {
			LayoutOrder = 2,
			Text = "Edit",
			Size = UDim2.new(1, -150, 0, 22),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(238, 238, 238),
			Font = Enum.Font.SourceSans,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
	})
end

local function PropertyTree(props)
	if not props.items then
		return Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Text = "Couldn't discover properties",
		})
	end

	local binding, setter = Roact.createBinding(0)

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),

			[Roact.Change.AbsoluteContentSize] = function(rbx)
				setter(rbx.AbsoluteContentSize.Y)
			end,
		})
	}

	for i = 1, #props.items do
		local item = props.items[i]
		if item.type == 'section' then
			children[i] = Roact.createElement(SectionItem, {
				LayoutOrder = i,
				depth = item.depth,
				sectionName = item.name,
			})
		elseif item.type == 'textInput' then
			children[i] = Roact.createElement(EditItem, {
				LayoutOrder = i,
				depth = item.depth,
				propertyName = item.propertyName,
			})
		end
	end

	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
		BackgroundTransparency = 1.0,
		BackgroundColor3 = Color3.fromRGB(96, 96, 96),
		CanvasSize = UDim2.new(0, 0, 0, binding.Y),
	}, children)
end

local function findIf(list, pred)
	return Cryo.List.filter(list, pred)[1]
end

local function mapStateToProps(state)
	local items = {}
	local foundProps = false

	if #state.selection == 1 then
		-- special case for now
		local selected = state.selection[1]
		local node = selected and findIf(state.nodes.list, function(node) return node.id == selected end)
		local type = node and node.type
		local component = type and findIf(state.stylebook.components, function(entry) return entry.name == type end)
		component = component and component.component
		local validateProps = component and component.validateProps

		local function recurseType(key, typeNode, depth)
			if typeNode.type == 'object' then
				items[#items+1] = {
					type = 'section',
					depth = depth,

					name = key,
				}
				for childKey, value in pairs(typeNode.shape) do
					recurseType(childKey, value, depth + 1)
				end
			elseif typeNode.type == 'optional' then
				recurseType(key, typeNode.validator, depth)
			elseif typeNode.type == 'primitive' then
				items[#items+1] = {
					type = 'textInput',
					depth = depth,

					propertyName = key,
					value = typeNode.type,
					setValue = function(newValue)
					end,
				}
			else
				warn("unknown predicate type "..typeNode.type)
			end
		end

		if validateProps then
			recurseType("Properties", validateProps, 0)
			foundProps = true
		end
	end

	return {
		items = foundProps and items,
	}
end

PropertyTree = RoactRodux.connect(mapStateToProps)(PropertyTree)

return PropertyTree
