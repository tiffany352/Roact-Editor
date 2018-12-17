local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ = require(ReplicatedStorage.Modules.TestEZ)

local RoactEditor = ReplicatedStorage.Modules.RoactEditor

TestEZ.TestBootstrap:run({ RoactEditor }, TestEZ.Reporters.TextReporter)