local Modules = script.Parent.Parent.Parent
local Cryo = require(Modules.Cryo)

local function findIf(list, pred)
	return Cryo.List.filter(list, pred)[1]
end

local defaultsForType = {
	string = "",
	number = 0,
	boolean = false,
	UDim2 = UDim2.new(),
}

--[[
	Given a node and a stylebook, generate a flat list of properties to
	show in a property editor widget. If extracting type information
	failed, returns false and a reason why.

	type Section = {
		type: 'section',
		depth: number,
		name: string,
	}

	type Property {
		type: 'property',
		depth: number,
		propertyName: string,
		propertyType: unknown,
		value: unknown,
	}

	type Button {
		type: 'button',
		depth: number,
	}

	type Label {
		type: 'label',
		depth: number,
		text: string,
	}

	type Item = Section|Property|Button|Label
]]
local function generatePropertyList(node, stylebook)
	local entry = findIf(stylebook.components, function(entry) return entry.name == node.type end)
	if not entry then
		return false, ("Component %q does not exist in stylebook"):format(tostring(node.type))
	end

	local component = entry.component
	if type(component) ~= 'table' then
		return false, "Functional components can't have typed props"
	end

	local validateProps = component.validateProps
	if not validateProps then
		return false, "Component does not have typed props"
	end

	local items = {}
	local function recurseType(key, typeNode, defaultValue, value, depth)
		local passValue
		if value ~= nil then
			passValue = value
		elseif defaultValue ~= nil then
			passValue = defaultValue
		else
			passValue = defaultsForType[typeNode.typeName]
		end

		if typeNode.type == 'object' then
			items[#items+1] = {
				type = 'section',
				depth = depth,

				name = key,
			}
			for childKey, childType in pairs(typeNode.shape) do
				recurseType(
					childKey,
					childType,
					defaultValue and defaultValue[childKey],
					value and value[childKey],
					depth + 1
				)
			end
		elseif typeNode.type == 'optional' then
			recurseType(key, typeNode.validator, defaultValue, value, depth)
		elseif typeNode.type == 'primitive' then
			items[#items+1] = {
				type = 'property',
				depth = depth,

				propertyName = key,
				propertyType = typeNode.typeName,
				value = passValue,
			}
		elseif typeNode.type == 'array' then
			items[#items+1] = {
				type = 'section',
				depth = depth,
				name = key,
			}
			for i = 1, #passValue do
				recurseType(i, typeNode.validator, nil, passValue[i], depth + 1)
			end
			items[#items+1] = {
				type = 'button',
				depth = depth + 1,
				label = 'Add Row',
			}
		elseif typeNode.type == 'enumOf' then
			items[#items+1] = {
				type = 'property',
				depth = depth,

				propertyName = key,
				propertyType = typeNode.enum,
				value = passValue,
			}
		else
			items[#items+1] = {
				type = 'label',
				depth = depth,
				text = string.format("Unknown type description: %q", tostring(typeNode.type))
			}
		end
	end

	recurseType("Properties", validateProps, component.defaultProps, node.props, 0)

	return items
end

return generatePropertyList
