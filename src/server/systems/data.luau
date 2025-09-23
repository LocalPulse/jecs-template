--[[ Services ]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--[[ Locations ]]
local Shared = ReplicatedStorage.Shared
local Packages = ReplicatedStorage.Packages
local ServerPackages = ServerScriptService.Packages

--[[ Packages ]]
local Jecs = require(Packages.Jecs)
local Lapis = require(ServerPackages.lapis)
local Planck = require(Packages.Planck)
local t = require(Packages.t)

--[[ Components ]]
local Components = require(Shared.components)
local ReplicationComponents = require(Shared.components.replication)

--[[ Constants ]]
local PLAYER_DATA = require(Shared.constants["player-data"])

--[[ Other ]]
local DataHelper = require(Shared.utils["data-helper"])
local DataJoinRemote: RemoteEvent = Shared.network["data-join"]

--[[ Private Functions ]]
local function createCollection()
	return Lapis.createCollection("PlayerData", {
		defaultData = PLAYER_DATA.StartData,
		validate = t.strictInterface(PLAYER_DATA.Schema),
	})
end

local function setUserId(world, entity, data)
	if data.PlayerId ~= 0 then
		return
	end
	local player: Player = world:get(entity, Components.PlayerRef)
	DataHelper.WriteData(world, entity, "PlayerId", player.UserId)
end

--[[ Private Variables ]]
local collection = createCollection()

local documents: { [Player]: any } = {}
local entityToPlayer: { [any]: Player } = {}

--[[ Handler ]]
local function playerData(world: Jecs.World)
	world:added(Components.PlayerRef, function(entity, id, player: Player)
		entityToPlayer[entity] = player
		collection
			:load(`Player{player.UserId}`, { player.UserId })
			:andThen(function(document)
				if player.Parent == nil then
					document:close():catch(warn)
					return
				end
				documents[player] = document
				world:set(entity, Components.Loaded, true)
				world:set(entity, Components.PlayerDocument, document)
				world:set(entity, ReplicationComponents.PlayerData, document.data)

				DataJoinRemote:FireClient(player, document.data)
				setUserId(world, entity, document.data)
			end)
			:catch(function(message)
				warn(`Player {player.Name}'s data failed to load: {message}`)
				player:Kick("Data failed to load, please reconnect")
			end)
	end)

	world:removed(Components.PlayerRef, function(entity, id)
		local player = entityToPlayer[entity]
		if not player then
			return
		end

		local document = documents[player]
		if document then
			document:close():catch(warn)
			documents[player] = nil
		end
		entityToPlayer[entity] = nil
	end)

	world:changed(ReplicationComponents.PlayerData, function(entity, id, value, oldarchetype)
		local player = entityToPlayer[entity]
		if not player then
			return
		end

		local success, errorMessage = t.strictInterface(PLAYER_DATA.Schema)(value)
		if not success then
			warn(`Failed to save data to {player.Name}: {errorMessage}`)
			player:Kick("Data failed to save, please reconnect")
			return
		end

		local document = documents[player]
		if document then
			document.data = value
			document:save():await()
		end
	end)
end

return {
	system = playerData,
	phase = Planck.Phase.PostStartup,
}
