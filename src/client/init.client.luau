local ReplicatedStorage = game:GetService("ReplicatedStorage")

local startup = require(ReplicatedStorage.Shared.startup)

local systems = {}

for _, system in script.systems:GetChildren() do
	if system:IsA("ModuleScript") then
		table.insert(systems, require(system))
	end
end

startup(systems)
