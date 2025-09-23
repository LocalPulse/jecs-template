local React = require(game.ReplicatedStorage.Packages.React)
local useLatestModule = require(script.Parent.useLatest)

local useLatest = useLatestModule.useLatest

local function useUnmountEffect(callback: () -> ())
	local callbackRef = useLatest(callback)
	React.useEffect(function()
		return function()
			callbackRef.current()
		end
	end, {})
end

return {
	useUnmountEffect = useUnmountEffect,
}
