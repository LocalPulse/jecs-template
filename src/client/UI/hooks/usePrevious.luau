local React = require(game.ReplicatedStorage.Packages.React)

export type Predicate<T> = (prev: T?, current: T) -> boolean

local function isStrictEqual(a: any, b: any): boolean
	return a == b
end

local function usePrevious<T>(value: T, predicate: Predicate<T>?): T?
	local pred = predicate or isStrictEqual
	local previousRef = React.useRef(nil :: T?)
	local currentRef = React.useRef(nil :: T?)
	React.useMemo(function()
		if not pred(currentRef.current, value) then
			previousRef.current = currentRef.current
			currentRef.current = value
		end
	end, { value })
	return previousRef.current
end

return {
	usePrevious = usePrevious,
	isStrictEqual = isStrictEqual,
}
