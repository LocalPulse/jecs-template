local packages = game.ReplicatedStorage.Packages
local shared = game.ReplicatedStorage.Shared

local React = require(packages.React)

local constants = require(shared.constants.game)
local IS_PLUGIN = constants.IS_PLUGIN

local function Layer(props: { displayOrder: number?, children: React.React_Node })
	local displayOrder = props.displayOrder
	local children = props.children

	if IS_PLUGIN then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			ZIndex = displayOrder,
		}, children)
	else
		return React.createElement("ScreenGui", {
			DisplayOrder = displayOrder,
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		}, children)
	end
end

return Layer
