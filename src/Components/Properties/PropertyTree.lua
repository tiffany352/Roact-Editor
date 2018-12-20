local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local Cryo = require(Modules.Cryo)
local setProp = require(Modules.Plugin.Actions.setProp)
local generatePropertyList = require(Modules.Plugin.Utilities.generatePropertyList)

local PropertyItem = require(script.Parent.PropertyItem)
local Switch = require(script.Parent.Switch)
local TextEdit = require(script.Parent.TextEdit)
local Dropdown = require(script.Parent.Dropdown)

local function SectionItem(props)
	return Roact.createElement(PropertyItem, {
		LayoutOrder = props.LayoutOrder,
		text = props.sectionName,
		depth = props.depth,
	})
end

local function PropertyTree(props)
	if props.noItemsReason then
		return Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1.0,
			TextWrapped = true,

			TextColor3 = Color3.fromRGB(0, 0, 0),
			Font = Enum.Font.SourceSans,
			TextSize = 22,
			Text = props.noItemsReason,
		})
	elseif not props.items then
		return nil
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
		elseif item.type == 'property' then
			local value = item.value
			local control
			local validate
			local filteredValue = value
			if item.propertyType == 'boolean' then
				control = Switch
			elseif item.propertyType == 'number' then
				control = TextEdit
				validate = function(text)
					local number = tonumber(text)
					if number then
						return true, number
					else
						return false
					end
				end
			elseif item.propertyType == 'UDim2' then
				control = TextEdit
				filteredValue = string.format(
					"%.2f, %d, %.2f, %d",
					value.X.Scale, value.X.Offset,
					value.Y.Scale, value.Y.Offset
				)
				validate = function(text)
					local terms = {}
					for term in text:gmatch("[^,]+") do
						terms[#terms+1] = term:gsub("^%s*(.*)%s*$", "%1")
					end
					if #terms ~= 4 then
						return false
					end
					local sx = tonumber(terms[1])
					local ox = tonumber(terms[2])
					local sy = tonumber(terms[3])
					local oy = tonumber(terms[4])
					if sx and ox and sy and oy then
						return true, UDim2.new(sx, ox, sy, oy)
					else
						return false
					end
				end
			elseif typeof(item.propertyType) == 'Enum' then
				control = Dropdown
			else
				control = TextEdit
			end
			children[i..tostring(control)] = Roact.createElement(PropertyItem, {
				LayoutOrder = i,
				depth = item.depth,
				text = item.propertyName,
			}, {
				Control = Roact.createElement(control, {
					value = filteredValue,
					setValue = function(newValue)
						local ok = true
						if validate then
							ok, newValue = validate(newValue)
						end
						if ok then
							print(item.propertyName, newValue)
							props.setProp(props.selectedNode, item.propertyName, newValue)
						end
					end,
				}),
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
	if #state.selection == 1 then
		-- special case for now
		local selected = state.selection[1]
		local node = selected and findIf(state.nodes.list, function(node) return node.id == selected end)
		local items, reason = generatePropertyList(node, state.stylebook)
		return {
			selectedNode = selected,
			items = items,
			noItemsReason = reason,
		}
	end

	return {}
end

local function mapDispatchToProps(dispatch)
	return {
		setProp = function(nodeId, propName, propValue)
			dispatch(setProp(nodeId, propName, propValue))
		end
	}
end

PropertyTree = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PropertyTree)

return PropertyTree
