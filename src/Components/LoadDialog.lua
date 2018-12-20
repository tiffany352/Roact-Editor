local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local closePrompt = require(Modules.Plugin.Actions.closePrompt)
local loadDocument = require(Modules.Plugin.Actions.loadDocument)

local Dialog = require(script.Parent.Dialog)
local Button = require(script.Parent.Button)
local PluginAccessor = require(script.Parent.PluginAccessor)

local LoadDialog = Roact.Component:extend("LoadDialog")

local background1 = Color3.fromRGB(255, 255, 255)
local background2 = Color3.fromRGB(238, 238, 238)
local hover = Color3.fromRGB(196, 196, 255)
local selected = Color3.fromRGB(160, 160, 255)

local rng = Random.new(0xbaadf00d)
local fakeItems = {}
for i = 1, 20 do
	local letters = "abcdefghijklmnopqrstuvwxyz "
	local s = ""
	for _ = 1, rng:NextInteger(5, 25) do
		local index = rng:NextInteger(1, #letters)
		s = s .. letters:sub(index, index)
	end
	local now = os.time()
	fakeItems[i] = {
		name = s,
		date = rng:NextInteger(now - 1e7, now),
	}
end
table.sort(fakeItems, function(a,b) return a.date > b.date end)

local function SaveItem(props)
	local date = os.date("*t", props.date)

	local color
	if props.selected then
		color = selected
	elseif props.hovered then
		color = hover
	elseif props.LayoutOrder % 2 == 0 then
		color = background1
	else
		color = background2
	end

	return Roact.createElement("ImageButton", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		AutoButtonColor = false,

		[Roact.Event.MouseEnter] = props.hoverEnter,
		[Roact.Event.MouseLeave] = props.hoverLeave,
		[Roact.Event.Activated] = props.onClick,
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
		}),
		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1.0,
			Size = UDim2.new(1, -125, 1, 0),
			TextColor3 = Color3.fromRGB(0, 0, 0),
			Font = Enum.Font.SourceSans,
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = props.name,
		}),
		Date = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1.0,
			Size = UDim2.new(0, 125, 1, 0),
			TextColor3 = Color3.fromRGB(0, 0, 0),
			Position = UDim2.new(1, -125, 0, 0),
			Font = Enum.Font.SourceSans,
			TextSize = 16,
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = string.format(
				"%04d-%02d-%02d %02d:%02d %s",
				date.year, date.month, date.day,
				date.hour % 12, date.min,
				date.hour >= 12 and "PM" or "AM"
			),
		}),
	})
end

function LoadDialog:render()
	if not self.props.enabled then
		return nil
	end

	local items = self.props.items

	local contentSize, contentSizeSetter = Roact.createBinding(0)

	local contentSizeRef = function(rbx)
		if rbx then
			contentSizeSetter(rbx.AbsoluteContentSize.Y)
		end
	end

	local children = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,

			[Roact.Ref] = contentSizeRef,
			[Roact.Change.AbsoluteContentSize] = contentSizeRef,
		})
	}

	for i = 1, #items do
		local item = items[i]

		children[i] = Roact.createElement(SaveItem, {
			LayoutOrder = i,
			name = item.name,
			date = item.date,
			hovered = self.state.hovered == i,
			selected = self.state.selected == i,

			hoverEnter = function()
				self:setState({
					hovered = i,
				})
			end,
			hoverLeave = function()
				if self.state.hovered == i then
					self:setState({
						hovered = Roact.None,
					})
				end
			end,
			onClick = function()
				self:setState({
					selected = i,
				})
			end,
		})
	end

	return Roact.createElement(Dialog, {
		name = "RoactLoadDialog",
		title = "Load saved UI",
		size = Vector2.new(400, 300),

		onClosed = function()
			self:setState({
				hovered = Roact.None,
				selected = Roact.None,
			})
			if self.props.onCancel then
				self.props.onCancel()
			end
		end,
	}, {
		ScrollingFrame = Roact.createElement("ScrollingFrame", {
			BackgroundColor3 = Color3.fromRGB(120, 120, 120),
			BorderColor3 = Color3.fromRGB(196, 196, 196),
			Size = UDim2.new(1, 0, 1, -40),
			VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			CanvasSize = contentSize:map(function(size)
				return UDim2.new(0, 0, 0, size)
			end),
		}, {
			Fill = Roact.createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(255,255,255),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
			}, children),
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
						hovered = Roact.None,
						selected = Roact.None,
					})
					if self.props.onCancel then
						self.props.onCancel()
					end
				end,
			}),

			Confirm = Roact.createElement(Button, {
				size = UDim2.new(0, 100, 0, 24),
				position = UDim2.new(0.5, 10, 1, -32),
				text = "Load",

				onClick = function()
					local result = self.state.selected
					self:setState({
						hovered = Roact.None,
						selected = Roact.None,
					})
					if self.props.onConfirm then
						self.props.onConfirm(items[result])
					end
				end,
			}),
		})
	})
end

local function InjectItemsFromSettings(props)
	return PluginAccessor.withPlugin(function(plugin)
		local items = plugin:getSetting("SavedDocuments") or {}

		return Roact.createElement(LoadDialog, {
			items = items,
			enabled = props.enabled,
			onCancel = props.onCancel,

			onConfirm = function(item)
				local save = plugin:getSetting("SavedDocuments_"..item.name)
				if not save then
					error("Missing save for "..item.name)
				end
				props.onConfirm(save.nodes)
			end,
		})
	end)
end

local function mapStateToProps(state)
	return {
		enabled = state.dialogState == 'Load',
		items = fakeItems,
	}
end

local function mapDispatchToProps(dispatch)
	return {
		onConfirm = function(nodes)
			dispatch(loadDocument(nodes))
		end,
		onCancel = function()
			dispatch(closePrompt())
		end,
	}
end

InjectItemsFromSettings = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(InjectItemsFromSettings)

return InjectItemsFromSettings
