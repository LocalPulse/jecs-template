--!strict
local types = require(script.Parent.Parent.types)

local ChangeHelper = {}
ChangeHelper.Storage = {} :: { [types.Entity]: { [types.Entity]: any } }
ChangeHelper.Previous = {} :: { [types.Entity]: { [types.Entity]: any } }

function ChangeHelper.Setup(world: types.World, components: { types.Entity })
	for _, component in components do
		ChangeHelper.Storage[component] = {}
		ChangeHelper.Previous[component] = {}

		world:added(component, function(entity, _, value)
			ChangeHelper.Storage[component][entity] = value
			ChangeHelper.Previous[component][entity] = value
		end)

		world:changed(component, function(entity, _, value)
			local storage = ChangeHelper.Storage[component]
			local prevStorage = ChangeHelper.Previous[component]

			prevStorage[entity] = storage[entity]

			storage[entity] = value
		end)

		world:removed(component, function(entity)
			local storage = ChangeHelper.Storage[component]
			local prevStorage = ChangeHelper.Previous[component]

			prevStorage[entity] = nil
			storage[entity] = nil
		end)
	end
end

function ChangeHelper.Get(world: types.World, component: types.Entity, entity: types.Entity)
	return ChangeHelper.Storage[component] and ChangeHelper.Storage[component][entity]
end

function ChangeHelper.GetPrevious(world: types.World, component: types.Entity, entity: types.Entity)
	return ChangeHelper.Previous[component] and ChangeHelper.Previous[component][entity]
end

return ChangeHelper
