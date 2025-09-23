local Replicated = game.ReplicatedStorage
local Packages = Replicated.Packages

local React = require(Packages.React)

local useUnmountEffect = require(script.Parent.useUnmountEffect).useUnmountEffect
local GetModelDiagonalLength = require(Replicated.Shared.utils.math).GetModelDiagonalLength

export type CameraSettings = {
	offsetBetweenModel: number?,
	customOffset: number?,
	customCFrame: CFrame?,
}

local function useModelViewport(originalModel: Model?, modelCFrame: CFrame?, settings: CameraSettings?)
	modelCFrame = modelCFrame or CFrame.new()
	settings = settings or {}
	if settings.customOffset == nil then
		settings.customOffset = 0
	end

	local viewportRef, setViewportRef = React.useState(nil :: ViewportFrame?)

	local modelRef = React.useRef(nil :: Model?)
	local cameraRef = React.useRef(nil :: Camera?)
	local _, forceUpdate = React.useState(0)

	React.useEffect(function()
		if not viewportRef or cameraRef.current then
			return
		end
		local cam = Instance.new("Camera")
		cam.Parent = viewportRef
		cameraRef.current = cam
		forceUpdate(function(v)
			return v + 1
		end)
	end, { viewportRef })

	React.useEffect(function()
		local cam = cameraRef.current
		if not viewportRef or not cam then
			return
		end

		local current = modelRef.current
		local needReplace = false
		if originalModel then
			if not current then
				needReplace = true
			elseif current.Name ~= originalModel.Name then
				needReplace = true
			end
		else
			if current then
				current:Destroy()
				modelRef.current = nil
				-- cleared
			end
			return
		end

		if needReplace then
			if current then
				current:Destroy()
			end
			local clone = originalModel:Clone()
			modelRef.current = clone
			clone.Parent = viewportRef
			clone:PivotTo(modelCFrame)
			forceUpdate(function(v)
				return v + 1
			end)
		else
			current:PivotTo(modelCFrame)
		end

		local activeModel = modelRef.current
		if not activeModel then
			return
		end

		if settings.customCFrame then
			cam.CFrame = settings.customCFrame
			return
		end

		local offsetBetween = settings.offsetBetweenModel
		if offsetBetween == nil then
			offsetBetween = 0.4
		end
		local distance = (settings.customOffset == 0) and (GetModelDiagonalLength(activeModel) / 2 + offsetBetween)
			or settings.customOffset
		cam.CFrame = CFrame.new(0, 0, distance)
	end, { viewportRef, originalModel, modelCFrame, settings })

	useUnmountEffect(function()
		local m = modelRef.current
		if m then
			m:Destroy()
		end
		local cam = cameraRef.current
		if cam then
			cam:Destroy()
		end
		modelRef.current = nil
		cameraRef.current = nil
	end)

	return setViewportRef, cameraRef.current, modelRef.current
end

return useModelViewport
