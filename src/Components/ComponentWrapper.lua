local TextService = game:GetService("TextService")

local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)

local ComponentWrapper = Roact.Component:extend("ComponentWrapper")

local Status = {
	New = 'New',
	Mounted = 'Mounted',
	Error = 'Error',
}

function ComponentWrapper:init(props)
	self.ref = Roact.createRef()
	self.status = Status.New
end

function ComponentWrapper:didMount()
	self:updateInner()
end

function ComponentWrapper:updateInner()
	local innerRoact = self.props.innerRoact
	local innerComponent = self.props.innerComponent
	local innerProps = self.props.innerProps

	local thread = coroutine.create(function()
		local element = innerRoact.createElement(innerComponent, innerProps)

		if self.handle then
			self.handle = innerRoact.reconcile(self.handle, element)
		else
			self.handle = innerRoact.mount(element, self.ref.current, "InnerComponent")
		end

		self.status = Status.Mounted
		self.error = nil
	end)
	local ok, error = coroutine.resume(thread)
	if not ok then
		self.handle = nil
		self.status = Status.Error

		local trace = debug.traceback(thread):gsub("Stack %w+\n?", "")
		local name = type(innerComponent) == 'function' and 'a functional component' or 'component '..tostring(innerComponent)

		self.error = string.format("In %s:\n%s\n\n%s", name, error, trace)
	end
end

function ComponentWrapper:willUnmount()
	if self.handle then
		pcall(function()
			self.props.innerRoact.unmount(self.handle)
		end)
	end
end

function ComponentWrapper:render()
	if self.ref.current then
		self:updateInner()
	end

	local children = {}

	local status = self.status
	if status == Status.Error then
		local text = self.error
		local font = Enum.Font.SourceSansBold
		local textSize = 20

		local bounds = TextService:GetTextSize(text, textSize, font, Vector2.new(0, 0))
		local errorGui = Roact.createElement("Frame", {
			Size = self.props.innerProps.Size or UDim2.new(1, 0, 1, 0),
			Position = self.props.innerProps.Size or UDim2.new(0, 0, 0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BorderColor3 = Color3.fromRGB(96, 0, 0),
		}, {
			ErrorText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1.0,
				Size = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextWrapped = true,
				Font = font,
				TextSize = textSize,
				Text = text,
			}, {
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(bounds.x, math.huge),
				})
			})
		})
		children.ErrorGui = errorGui
	end

	return Roact.createElement("Folder", {
		[Roact.Ref] = self.ref,
	}, children)
end

return ComponentWrapper
