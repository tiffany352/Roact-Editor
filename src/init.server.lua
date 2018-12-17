-- Generator information:
-- Human name: Roact Editor
-- Variable name: RoactEditor
-- Repo name: roact-editor

local hello = require(script.hello)

local toolbar = plugin:CreateToolbar("Roact Editor")

local toolbarButton = toolbar:CreateButton("Say Hello", "Says hello in the output", "")
toolbarButton.Click:Connect(function()
	print(hello())
end)