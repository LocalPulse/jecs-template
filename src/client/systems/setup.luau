local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared

local Jecs = require(ReplicatedStorage.Packages.Jecs)
local Planck = require(ReplicatedStorage.Packages.Planck)

local ReplicationComponents = require(Shared.components.replication)

local Patcher = require(Shared.utils.patcher)
local DataJoinRemote: RemoteEvent = Shared.network["data-join"]
local DataPatchesRemote: RemoteEvent = Shared.network["data-patches"]

local function setup(world: Jecs.World)
	local entity = world:entity()
	world:set(entity, Jecs.Name, "LocalPlayer")

	DataJoinRemote.OnClientEvent:Once(function(data)
		world:set(entity, ReplicationComponents.PlayerData, data)
	end)

	DataPatchesRemote.OnClientEvent:Connect(function(patch)
		local prevData = world:get(entity, ReplicationComponents.PlayerData)
		local nextData = Patcher.apply(prevData, patch)
		world:set(entity, ReplicationComponents.PlayerData, nextData)
		print(world:get(entity, ReplicationComponents.PlayerData))
	end)
end

return {
	system = setup,
	phase = Planck.Phase.PreStartup,
}
