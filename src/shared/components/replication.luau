local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Jecs = require(ReplicatedStorage.Packages.Jecs)
local world = require(ReplicatedStorage.Shared.world)

local START_PLAYER_DATA = require(ReplicatedStorage.Shared.constants["player-data"]).StartData
type PlayerData = typeof(START_PLAYER_DATA)

return table.freeze({
	PlayerData = world:component() :: Jecs.Entity<PlayerData>,
})
