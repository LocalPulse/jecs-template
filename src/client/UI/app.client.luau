--[[ Services ]]
local Players = game:GetService("Players")

--[[ Private Variables]]
local Packages = game.ReplicatedStorage.Packages

local React = require(Packages.React)
local ReactRoblox = require(Packages["React-roblox"])

local App = require(script.Parent.components.app)

local root = ReactRoblox.createRoot(Instance.new("Folder"))
local target = Players.LocalPlayer:WaitForChild("PlayerGui")

root:render(React.createElement(React.StrictMode, {}, {
	ReactRoblox.createPortal(React.createElement(App), target, {}),
}))
