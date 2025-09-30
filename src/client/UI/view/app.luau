local Packages = game:GetService("ReplicatedStorage").Packages

local Layer = require(script.Parent.layer)
local React = require(Packages.React)

local WorldProvider = require(script.Parent.Parent.hooks.useJecsHooks).WorldProvider
local world = require(game.ReplicatedStorage.Shared.world)

local function App()
	return React.createElement(WorldProvider, {
		world = world,
	}, {
		React.createElement(Layer, {}, {
			--Paste your gui
		}),
	})
end

return App
