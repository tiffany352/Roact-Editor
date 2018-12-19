local ComponentWrapperError = require(script.Parent.ComponentWrapperError)

local Status = {
	New = 'New',
	Mounted = 'Mounted',
	Error = 'Error',
}

local function createComponentWrapper(HostRoact, ChildRoact)
	local ComponentWrapper = HostRoact.Component:extend("ComponentWrapper")

	function ComponentWrapper:init(props)
		self.ref = HostRoact.createRef()
		self.status = Status.New
	end

	function ComponentWrapper:didMount()
		self:updateInner()
	end

	function ComponentWrapper:updateInner()
		local thread = coroutine.create(function()
			local element = HostRoact.oneChild(self.props[HostRoact.Children])

			if self.handle then
				if ChildRoact.update then
					self.handle = ChildRoact.update(self.handle, element)
				else
					self.handle = ChildRoact.reconcile(self.handle, element)
				end
			else
				self.handle = ChildRoact.mount(element, self.ref.current, "InnerComponent")
			end

			self.status = Status.Mounted
			self.error = nil
		end)
		local ok, error = coroutine.resume(thread)
		if not ok then
			self.handle = nil
			self.status = Status.Error

			local trace = debug.traceback(thread):gsub("Stack %w+\n?", "")

			self.error = string.format("%s\n\n%s", error, trace)
		end
	end

	function ComponentWrapper:willUnmount()
		if self.handle then
			pcall(function()
				ChildRoact.unmount(self.handle)
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
			children.ErrorGui = HostRoact.createElement(ComponentWrapperError, {
				error = self.error,
			})
		end

		return HostRoact.createElement("Folder", {
			[HostRoact.Ref] = self.ref,
		}, children)
	end

	return ComponentWrapper
end

return createComponentWrapper
