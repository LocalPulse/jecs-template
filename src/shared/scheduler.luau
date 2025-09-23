local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)
local PlanckJabby = require(ReplicatedStorage.Packages.PlanckJabby)
local PlanckRunService = require(ReplicatedStorage.Packages.PlanckRunService)
local MatterHooks = require(ReplicatedStorage.Packages.MatterHooks)

local world = require(ReplicatedStorage.Shared.world)

local scheduler = Planck.Scheduler
	.new(world)
	:addPlugin(PlanckJabby.new())
	:addPlugin(PlanckRunService.Plugin.new())
	:addPlugin(MatterHooks.Plugin.new())

return scheduler
