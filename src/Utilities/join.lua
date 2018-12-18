local function join(left, right)
	local new = {}

	for key, value in pairs(left) do
		new[key] = value
	end

	for key, value in pairs(right) do
		new[key] = value
	end

	return new
end

return join
