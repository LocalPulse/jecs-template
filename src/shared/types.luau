local PLAYER_DATA = require(game.ReplicatedStorage.Shared.constants["player-data"])
local jecs = require(game.ReplicatedStorage.Packages.Jecs)

export type World = typeof(jecs.world())
export type Entity = jecs.Entity<any>

export type PlayerData = typeof(PLAYER_DATA.StartData)
export type PlayerDataKeys = keyof<PlayerData>

return {}
