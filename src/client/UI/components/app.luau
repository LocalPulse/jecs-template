local Packages = game:GetService("ReplicatedStorage").Packages

local Layer = require(script.Parent.layer)
local React = require(Packages.React)

local function App()
	return React.createElement(Layer, {}, {
		Test = React.createElement("Frame", {
			Visible = false,
		}),
	})
end

return App
