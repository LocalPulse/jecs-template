local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared

local Jecs = require(ReplicatedStorage.Packages.Jecs)
local Planck = require(ReplicatedStorage.Packages.Planck)

local ChangeHelper = require(Shared.utils["change-helper"])
local Patcher = require(Shared.utils.patcher)

local Components = require(Shared.components)
local ReplicationComponents = require(Shared.components.replication)

local DataPatchRemote = Shared.network["data-patches"]

local function replication(world: Jecs.World)
	for _, component in ReplicationComponents do
		world:changed(component, function(entity, _, value)
			local player = world:get(entity, Components.PlayerRef)

			local prevState = ChangeHelper.GetPrevious(world, component, entity)
			DataPatchRemote:FireClient(player, Patcher.diff(prevState, value))
		end)
	end
end

return {
	system = replication,
	phase = Planck.Phase.PreStartup,
}
