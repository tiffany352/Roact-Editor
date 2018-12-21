local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local Cryo = require(Modules.Cryo)
local closePrompt = require(Modules.Plugin.Actions.closePrompt)
local Serializer = require(Modules.Plugin.Utilities.Serializer)

local Dialog = require(script.Parent.Dialog)
local Button = require(script.Parent.Button)
local PluginAccessor = require(script.Parent.PluginAccessor)

local SaveDialog = Roact.Component:extend("SaveDialog")

function SaveDialog:render()
	if not self.props.enabled then
		return nil
	end

	local textboxRef = Roact.createRef()

	return Roact.createElement(Dialog, {
		name = "RoactSaveDialog",
		title = "Create saved UI",
		size = Vector2.new(400, 150),

		onClosed = function()
			self:setState({
				alreadyTaken = false,
				text = '',
			})
			if self.props.onCancel then
				self.props.onCancel()
			end
		end,
	}, {
		Background = Roact.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(250, 250, 250),
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			Input = Roact.createElement("ImageButton", {
				Size = UDim2.new(1, -50, 0, 32),
				Position = UDim2.new(0.5, 0, 0.5, -20),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = self.state.alreadyTaken and
					Color3.fromRGB(255, 200, 200) or
					Color3.fromRGB(255, 255, 255),
				BorderColor3 = self.state.alreadyTaken and
					Color3.fromRGB(255, 160, 160) or
					Color3.fromRGB(220, 220, 220),
				AutoButtonColor = false,

				[Roact.Event.Activated] = function()
					if textboxRef.current then
						textboxRef.current:CaptureFocus()
					end
				end,
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
				}),
				TextBox = Roact.createElement("TextBox", {
					BackgroundTransparency = 1.0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = self.state.text or '',
					PlaceholderText = "Enter filename",
					TextColor3 = Color3.fromRGB(0, 0, 0),
					Font = Enum.Font.SourceSans,
					TextSize = 18,
					TextXAlignment = Enum.TextXAlignment.Left,

					[Roact.Ref] = textboxRef,

					[Roact.Change.Text] = function(rbx)
						local text = rbx.Text
						local taken = self.props.checkIfTaken(text)
						self:setState({
							text = text,
							alreadyTaken = taken,
						})
					end,
				}),
				ValidationText = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1.0,
					Size = UDim2.new(1, 0, 0, 16),
					Position = UDim2.new(0, 0, 1, 2),
					Font = Enum.Font.SourceSans,
					TextSize = 16,
					TextColor3 = Color3.fromRGB(196, 0, 0),
					Text = self.state.alreadyTaken and "Filename already in use" or "",
					TextXAlignment = Enum.TextXAlignment.Left,
				}),
			}),
			BottomBar = Roact.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(238, 238, 238),
				BorderColor3 = Color3.fromRGB(196, 196, 196),
				Position = UDim2.new(0, 0, 1, -40),
				Size = UDim2.new(1, 0, 0, 40),
			}, {
				Cancel = Roact.createElement(Button, {
					size = UDim2.new(0, 100, 0, 24),
					position = UDim2.new(0.5, -110, 1, -32),
					text = "Cancel",

					onClick = function()
						self:setState({
							alreadyTaken = false,
							text = '',
						})
						if self.props.onCancel then
							self.props.onCancel()
						end
					end,
				}),

				Confirm = Roact.createElement(Button, {
					size = UDim2.new(0, 100, 0, 24),
					position = UDim2.new(0.5, 10, 1, -32),
					text = "Save",
					disabled = self.state.alreadyTaken,

					onClick = function()
						local name = self.state.text
						self:setState({
							alreadyTaken = false,
							text = '',
						})
						if self.props.onConfirm then
							self.props.onConfirm(name)
						end
					end,
				}),
			})
		})
	})
end

local function InjectPluginFuncs(props)
	return PluginAccessor.withPlugin(function(plugin)
		return Roact.createElement(SaveDialog, {
			enabled = props.enabled,
			onCancel = props.onCancel,

			checkIfTaken = function(name)
				local result = plugin:getSetting("SavedDocuments_"..name)
				return result ~= nil or name == "AlreadyTaken"
			end,

			onConfirm = function(name)
				local document = {
					version = 2,
					nodes = Cryo.Dictionary.join(props.nodes, {
						list = Cryo.List.map(props.nodes.list, function(node)
							return Cryo.Dictionary.join(node, {
								props = Serializer.encode(node.props),
							})
						end)
					}),
				}

				assert(document.version == 2)
				assert(type(document.nodes) == 'table')
				assert(type(document.nodes.nextId) == 'number')
				assert(type(document.nodes.list) == 'table')
				assert(#document.nodes.list >= 1)
				assert(document.nodes.list[1].props.type == 'table')

				plugin:setSetting("SavedDocuments_"..name, document)
				local items = plugin:getSetting("SavedDocuments") or {}
				items[#items+1] = {
					name = name,
					date = os.time(),
				}
				plugin:setSetting("SavedDocuments", items)

				props.onConfirm()
			end,
		})
	end)
end

local function mapStateToProps(state)
	return {
		enabled = state.dialogState == 'Save',
		-- for saving
		nodes = state.nodes,
	}
end

local function mapDispatchToProps(dispatch)
	return {
		onConfirm = function(name)
			dispatch(closePrompt())
		end,
		onCancel = function()
			dispatch(closePrompt())
		end,
	}
end

InjectPluginFuncs = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(InjectPluginFuncs)

return InjectPluginFuncs
