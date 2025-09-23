local React = require(game.ReplicatedStorage.Packages.React)
local lerp = function(a: number, b: number, alpha: number)
	return a + (b - a) * alpha
end

export type Binding<T> = {
	getValue: (self: Binding<T>) -> T,
	map: <U>(self: Binding<T>, mapper: (T) -> U) -> Binding<U>,
}

export type BindingApi<T> = {
	subscribe: (callback: (T) -> ()) -> () -> (),
	update: (newValue: T) -> (),
	getValue: () -> T,
}

export type Lerpable<T> = {
	Lerp: (self: T, to: T, alpha: number) -> T,
}

local function isBinding(value: any): boolean
	return typeof(value) == "table" and value.getValue ~= nil and value.map ~= nil
end

local function toBinding<T>(value: T | Binding<T>): Binding<T>
	if isBinding(value) then
		return value :: any
	end
	local binding, setValue = React.createBinding(value)
	return binding
end

local function getBindingValue<T>(bindingOrValue: T | Binding<T>): T
	if isBinding(bindingOrValue) then
		return (bindingOrValue :: any):getValue()
	end
	return bindingOrValue :: any
end

local function mapBinding<T, U>(bindingOrValue: T | Binding<T>, mapper: (T) -> U): Binding<U>
	if isBinding(bindingOrValue) then
		return (bindingOrValue :: any):map(mapper)
	end
	local binding, setValue = React.createBinding(mapper(bindingOrValue :: T))
	return binding
end

local function joinAnyBindings(bindings: any): Binding<any>
	local converted = {}
	for k, v in bindings do
		converted[k] = toBinding(v)
	end
	if React.joinBindings then
		return React.joinBindings(converted)
	end
	local initialSnapshot = {}
	for k, b in converted do
		initialSnapshot[k] = b:getValue()
	end
	local merged, setMerged = React.createBinding(initialSnapshot)

	for key, b in converted do
		b:map(function()
			local snap = {}
			for k2, b2 in converted do
				snap[k2] = b2:getValue()
			end
			setMerged(snap)
			return
		end)
	end
	return merged
end

local function getBindingApi<T>(binding: Binding<T>): BindingApi<T>?
	for k, v in binding do
		local name = tostring(k)
		if name == "Symbol(BindingImpl)" or string.sub(tostring(name), 1, 12) == "RoactBinding" then
			return v
		end
	end
	return
end

local function lerpBinding<T>(alphaBinding: Binding<number> | number, from: T, to: T): Binding<any>
	return mapBinding(alphaBinding, function(alpha: number)
		if typeof(from) == "number" then
			return lerp(from, to :: any, alpha)
		else
			return (from :: any):Lerp(to, alpha)
		end
	end)
end

local function composeBindings(...: any): Binding<any>
	local args = { ... }
	local combiner = args[#args]
	table.remove(args, #args)
	for i = 1, #args do
		args[i] = toBinding(args[i])
	end
	local joined = joinAnyBindings(args)
	return joined:map(function(valuesSnapshot)
		local ordered = {}
		if #args > 0 then
			for i = 1, #args do
				ordered[i] = valuesSnapshot[i]
			end
		else
			for k, v in valuesSnapshot do
				ordered[k] = v
			end
		end
		return combiner(table.unpack(ordered))
	end)
end

return {
	isBinding = isBinding,
	toBinding = toBinding,
	getBindingValue = getBindingValue,
	mapBinding = mapBinding,
	joinAnyBindings = joinAnyBindings,
	getBindingApi = getBindingApi,
	lerpBinding = lerpBinding,
	composeBindings = composeBindings,
}
