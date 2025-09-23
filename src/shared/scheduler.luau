local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Planck = require(ReplicatedStorage.Packages.Planck)
local PlanckJabby = require(ReplicatedStorage.Packages.PlanckJabby)
local PlanckRunService = require(ReplicatedStorage.Packages.PlanckRunService)

local world = require(ReplicatedStorage.Shared.world)

local scheduler = Planck.Scheduler.new(world):addPlugin(PlanckJabby.new()):addPlugin(PlanckRunService.Plugin.new())

return scheduler
