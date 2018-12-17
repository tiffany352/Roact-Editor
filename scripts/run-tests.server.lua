local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ = require(ReplicatedStorage.Modules.TestEZ)

local RoactEditor = ReplicatedStorage.Modules.Plugin

TestEZ.TestBootstrap:run({ RoactEditor }, TestEZ.Reporters.TextReporter)