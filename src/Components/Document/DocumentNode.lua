local Modules = script.Parent.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local ComponentWrapper = require(Modules.Plugin.Components.ComponentWrapper)

local function DocumentNode(props)
	local component = props.tree.component
	local innerProps = props.tree.props

	if props.innerRoact and component then
		return Roact.createElement(ComponentWrapper, {
			innerRoact = props.innerRoact,
			innerComponent = component,
			innerProps = innerProps,
		})
	else
		return nil
	end
end

return DocumentNode
