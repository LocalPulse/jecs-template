local RunService = game:GetService("RunService")

local Packages = game.ReplicatedStorage.Packages
local React = require(Packages.React)

local BindingUtils = require(script.Parent.Parent.utils.binding)
local useMotion = require(script.Parent.useMotion)
local useEventListener = require(script.Parent.useEventListener).useEventListener

local getBindingValue = BindingUtils.getBindingValue

local function useSpring(goal: any, options: any?): any
	local startValue = getBindingValue(goal)
	local binding, motion = useMotion(startValue)
	local prevRef = React.useRef(startValue)

	useEventListener(RunService.Heartbeat, function()
		local current = getBindingValue(goal)
		if current ~= prevRef.current then
			prevRef.current = current
			if motion.spring then
				motion:spring(current, options)
			elseif motion.setGoal then
				motion:setGoal(current)
			end
		end
	end, { connected = true })

	return binding
end

return {
	useSpring = useSpring,
}
