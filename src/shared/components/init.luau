local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Jecs = require(ReplicatedStorage.Packages.Jecs)
local world = require(ReplicatedStorage.Shared.world)

return {
	PlayerRef = world:component() :: Jecs.Entity<Player>,
	Loaded = world:component() :: Jecs.Entity<boolean>,
	PlayerDocument = world:component() :: Jecs.Entity<any>,
}
