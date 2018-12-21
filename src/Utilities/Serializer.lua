local Serializer = {}

local primitiveTypes = {
	number = true,
	string = true,
	boolean = true,
}

local objectLikeTypes = {
	Vector2 = {
		X = true,
		Y = true,
	},
	UDim = {
		Scale = true,
		Offset = true,
	},
	UDim2 = {
		X = true,
		Y = true,
	},
}

local constructObject = {
	Vector2 = function(args)
		return Vector2.new(args.X, args.Y)
	end,
	UDim = function(args)
		return UDim.new(args.Scale, args.Offset)
	end,
	UDim2 = function(args)
		return UDim2.new(args.X, args.Y)
	end,
}

function Serializer.encode(value)
	local ty = typeof(value)

	if ty == 'nil' then
		return nil
	elseif primitiveTypes[ty] then
		return {
			type = 'primitive',
			value = value,
		}
	elseif objectLikeTypes[ty] then
		local fields = objectLikeTypes[ty]

		local encoded = {}
		for key in pairs(fields) do
			encoded[key] = Serializer.encode(value[key])
		end
		return {
			type = 'struct',
			structType = ty,
			value = encoded,
		}
	elseif ty == 'EnumItem' then
		return {
			type = 'enum',
			enumType = tostring(value.EnumType),
			enumItem = value.Name,
		}
	elseif ty == 'table' then
		local encoded = {}
		for key, subValue in pairs(value) do
			encoded[key] = Serializer.encode(subValue)
		end
		return {
			type = 'table',
			value = encoded,
		}
	else
		error(string.format("Serializer.encode doesn't handle type %q", ty))
	end
end

function Serializer.decode(input)
	if input == nil then
		return nil
	elseif input.type == 'primitive' then
		return input.value
	elseif input.type == 'struct' then
		local decoded = {}
		for key, value in pairs(input.value) do
			decoded[key] = Serializer.decode(value)
		end
		return constructObject[input.structType](decoded)
	elseif input.type == 'enum' then
		return Enum[input.enumType][input.enumItem]
	elseif input.type == 'table' then
		local decoded = {}
		for key, value in pairs(input.value) do
			decoded[key] = Serializer.decode(value)
		end
		return decoded
	else
		warn(string.format("Serializer.decode doesn't handle type %q", tostring(input.type)))
		return nil
	end
end

return Serializer
