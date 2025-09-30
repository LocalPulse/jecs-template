local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local Packages = ReplicatedStorage.Packages

local Jecs = require(Packages.Jecs)
local Planck = require(Packages.Planck)
local React = require(Packages.React)
local ReactRoblox = require(Packages["React-roblox"])

local ReplicationComponents = require(Shared.components.replication)

local Patcher = require(Shared.utils.patcher)
local DataJoinRemote: RemoteEvent = Shared.network["data-join"]
local DataPatchesRemote: RemoteEvent = Shared.network["data-patches"]

local App = require(Players.LocalPlayer.PlayerScripts.Client.UI.view.app)

local function setup(world: Jecs.World)
	local entity = world:entity()
	world:set(entity, Jecs.Name, "LocalPlayer")

	--[[ Data Events ]]
	DataJoinRemote.OnClientEvent:Once(function(data)
		world:set(entity, ReplicationComponents.PlayerData, data)
	end)

	DataPatchesRemote.OnClientEvent:Connect(function(patch)
		local prevData = world:get(entity, ReplicationComponents.PlayerData)
		local nextData = Patcher.apply(prevData, patch)
		world:set(entity, ReplicationComponents.PlayerData, nextData)
	end)

	--[[ UI Setup ]]
	local root = ReactRoblox.createRoot(Instance.new("Folder"))
	local target = Players.LocalPlayer:WaitForChild("PlayerGui")
	root:render(React.createElement(React.StrictMode, {}, {
		ReactRoblox.createPortal(React.createElement(App), target, {}),
	}))
end

return {
	system = setup,
	phase = Planck.Phase.PreStartup,
}
