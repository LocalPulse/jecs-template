local RunService = game:GetService("RunService")
return table.freeze({
	IS_PLUGIN = RunService:IsStudio() and not RunService:IsRunning(),
})
