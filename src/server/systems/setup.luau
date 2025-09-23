local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared

local Jecs = require(ReplicatedStorage.Packages.Jecs)
local Planck = require(ReplicatedStorage.Packages.Planck)

local ReplicationComponents = require(Shared.components.replication)

local ChangeHelper = require(Shared.utils["change-helper"])

local function setup(world: Jecs.World)
	ChangeHelper.Setup(world, ReplicationComponents)
end

return {
	system = setup,
	phase = Planck.Phase.PreStartup,
}
