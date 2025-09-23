local React = require(game.ReplicatedStorage.Packages.React)
local usePreviousModule = require(script.Parent.usePrevious)

local isStrictEqual = usePreviousModule.isStrictEqual

export type Predicate<T> = (prev: T?, current: T) -> boolean

local function useLatest<T>(value: T, predicate: Predicate<T>?): { current: T }
	local pred = predicate or isStrictEqual
	local ref = React.useRef(value)
	React.useEffect(function()
		if not pred(ref.current, value) then
			ref.current = value
		end
	end, { value })
	return ref
end

return {
	useLatest = useLatest,
	isStrictEqual = isStrictEqual,
}
