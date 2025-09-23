local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local Jecs = require(game.ReplicatedStorage.Packages.Jecs)
local Jabby = require(game.ReplicatedStorage.Packages.Jabby)

local scheduler = require(script.Parent.scheduler)
local world = require(script.Parent.world)

local components = require(script.Parent.components)
local replicationComponents = require(script.Parent.components.replication)

return function(systems)
	if #systems ~= 0 then
		scheduler:addSystems(systems) -- Assuming you're using SystemTables!
	end

	for name, comp in components do
		world:set(comp, Jecs.Name, name)
	end

	for name, comp in replicationComponents do
		world:set(comp, Jecs.Name, name)
	end

	if RunService:IsClient() then
		local client = Jabby.obtain_client()

		local function createWidget(_, state: Enum.UserInputState)
			if state ~= Enum.UserInputState.Begin then
				return
			end

			client.spawn_app(client.apps.home, nil)
		end

		ContextActionService:BindAction("Open Jabby", createWidget, false, Enum.KeyCode.F4)
	end

	Jabby.register({
		applet = Jabby.applets.world,
		name = "Jecs World",
		configuration = {
			world = world,
		},
	})
end
