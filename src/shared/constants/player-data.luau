local ReplicatedStorage = game.ReplicatedStorage
local t = require(ReplicatedStorage.Packages.t)

local StartDataSchema = {
	PlayerId = t.number,
	RobuxSpend = t.number,
	PlayTime = t.number,
}

local StartData = {
	PlayerId = 0,
	PlayTime = 0,
	RobuxSpend = 0,
}

export type DataType = typeof(StartData)
export type DataKeysType = keyof<DataType>

return {
	Schema = StartDataSchema,
	StartData = StartData,
}
