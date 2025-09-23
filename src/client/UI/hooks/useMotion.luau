local RunService = game:GetService("RunService")
local Packages = game.ReplicatedStorage.Packages

local React = require(Packages.React)
local Ripple = require(Packages.Ripple)

local createMotion = Ripple.createMotion

export type Motion<T> = {
	step: (self: Motion<T>, dt: number) -> T,
	setGoal: (self: Motion<T>, goal: any) -> (),
}

type Callback = (number) -> ()

local callbacks: { Callback } = {}
local connection: RBXScriptConnection? = nil

local function connect(cb: Callback)
	callbacks[#callbacks + 1] = cb
	if connection then
		return
	end
	connection = RunService.Heartbeat:Connect(function(dt)
		for i = 1, #callbacks do
			callbacks[i](dt)
		end
	end)
end

local function disconnect(cb: Callback)
	for i = 1, #callbacks do
		if callbacks[i] == cb then
			table.remove(callbacks, i)
			break
		end
	end
	if #callbacks == 0 and connection then
		connection:Disconnect()
		connection = nil
	end
end

local function useMotion(initialValue: any)
	local motionRef = React.useRef(nil :: Motion<any>?)
	if motionRef.current == nil then
		motionRef.current = createMotion(initialValue)
	end
	local motion = motionRef.current :: Motion<any>

	local binding, setValue = React.useBinding(initialValue)

	React.useEffect(function()
		local function onStep(dt: number)
			local v = motion:step(dt)
			if v ~= binding:getValue() then
				setValue(v)
			end
		end
		connect(onStep)
		return function()
			disconnect(onStep)
		end
	end, {})

	return binding, motion
end

return useMotion
