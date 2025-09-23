local jecs = require(game.ReplicatedStorage.Packages.Jecs)

export type World = typeof(jecs.world())
export type Entity = jecs.Entity<any>
export type Snapshot = {
	[string]: {
		set: { jecs.Entity<nil> }?,
		values: { any }?,
		removed: { jecs.Entity<nil> }?,
	},
}

return {}
