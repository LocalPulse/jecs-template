local Sift = require(game.ReplicatedStorage.Packages.Sift)
local t = require(game.ReplicatedStorage.Packages.t)

local ReplicationComponents = require(game.ReplicatedStorage.Shared.components.replication)

local PLAYER_DATA = require(game.ReplicatedStorage.Shared.constants["player-data"])
type PlayerDataType = typeof(PLAYER_DATA.StartData)

local DataHelper = {}

local function mergeDataImpl(key, value: any, oldData: PlayerDataType): PlayerDataType
	assert(t.string(key), "WriteData expects a string key")

	local base = oldData or (PLAYER_DATA.StartData :: PlayerDataType)
	local newData = Sift.Dictionary.mergeDeep(base, { [key] = value })
	local success, errorMessage = t.strictInterface(PLAYER_DATA.Schema)(newData)

	if not success then
		error(`Failed to write data: {errorMessage}`)
	end

	return newData
end

DataHelper.MergeData = mergeDataImpl

function DataHelper.WriteData(world, entity, key, value: any)
	local oldData: PlayerDataType = world:get(entity, ReplicationComponents.PlayerData)
	local success, result = pcall(mergeDataImpl, key, value, oldData)
	if not success then
		return
	end

	local newData: PlayerDataType? = result
	if newData == nil then
		return
	end

	world:set(entity, ReplicationComponents.PlayerData, newData)
end

return DataHelper
