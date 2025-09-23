local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared

local Jecs = require(ReplicatedStorage.Packages.Jecs)
local Planck = require(ReplicatedStorage.Packages.Planck)

local Components = require(Shared.components)

local function playerSetup(world: Jecs.World)
	local connection: { [number]: RBXScriptConnection } = {}
	local players: { [Player]: number } = {}

	connection[#connection + 1] = Players.PlayerAdded:Connect(function(player)
		local entity = world:entity()
		players[player] = entity

		world:set(entity, Jecs.Name, player.Name)
		world:set(entity, Components.PlayerRef, player)
		world:set(entity, Components.Loaded, false)
	end)

	connection[#connection + 1] = Players.PlayerRemoving:Connect(function(player)
		world:delete(players[player])
		players[player] = nil
	end)
end

return {
	system = playerSetup,
	phase = Planck.Phase.Startup,
}
