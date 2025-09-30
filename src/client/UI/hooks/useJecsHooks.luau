local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Jecs = require(ReplicatedStorage.Packages.Jecs)
local React = require(ReplicatedStorage.Packages.React)
local jecs = require(ReplicatedStorage.Packages.Jecs)
local observer = require(ReplicatedStorage.Shared.utils["jecs-addon"])

local WorldContext = React.createContext(nil)

local function WorldProvider(props)
	local world = props.world
	assert(world, "WorldProvider requires a 'world' prop (initialized Jecs world)")

	return React.createElement(WorldContext.Provider, {
		value = world,
	}, props.children)
end

local function useWorld(): Jecs.World
	local world = React.useContext(WorldContext)
	assert(world, "useWorld must be used within a <WorldProvider>")
	return world
end

local function useComponent(entity, component)
	assert(entity, "Expected Entity got nil")
	assert(component, "Expected component got nil")

	local world = useWorld()

	local value, setValue = React.useState(world:get(entity, component))

	React.useEffect(function()
		local unsubAdd = world:added(component, function(e, _id, v)
			if e == entity then
				setValue(v)
			end
		end)
		local unsubChange = world:changed(component, function(e, _id, v)
			if e == entity then
				setValue(v)
			end
		end)

		local unsubRemove = world:removed(component, function(e)
			if e == entity then
				setValue(nil)
			end
		end)

		return function()
			unsubAdd()
			unsubChange()
			unsubRemove()
		end
	end, { entity, component, world })

	return value
end

-- Tracks entities matching specific components
local function useQuery(query)
	assert(query, "Expected Query got nil")

	local entities, setEntities = React.useState(function()
		local list = {}
		for e in query do
			table.insert(list, e)
		end
		return list
	end)
	React.useEffect(function()
		local current = {}
		local newList = {}

		for e in query do
			current[e] = true
			table.insert(newList, e)
		end
		setEntities(newList)
		local function updateEntity(e, event)
			if event == jecs.OnAdd then
				current[e] = true
			elseif event == jecs.OnRemove then
				current[e] = nil
			end

			local newList = {}
			for ent in pairs(current) do
				table.insert(newList, ent)
			end
			setEntities(newList)
		end
		local unsubObs = observer.observer(table.clone(query), function(e)
			updateEntity(e)
		end)
		local unsubMon = observer.monitor(table.clone(query), function(e, event)
			updateEntity(e, event)
		end)
		return function()
			unsubObs.disconnect()
			unsubMon.disconnect()
		end
	end, { unpack(query.ids) })
	return entities
end

local function useEntity(entity, ...)
	local components = { ... }

	local values = {}
	for i, component in components do
		values[i] = useComponent(entity, component)
	end

	return values
end

return {
	WorldProvider = WorldProvider,
	useWorld = useWorld,
	useComponent = useComponent,
	useQuery = useQuery,
	useEntity = useEntity,
}
