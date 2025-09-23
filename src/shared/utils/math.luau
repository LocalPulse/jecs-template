local function GetModelDiagonalLength(model: Model): number
	if not model then
		return 0
	end
	local size = model:GetExtentsSize()
	return size.Magnitude / 2
end

return {
	GetModelDiagonalLength = GetModelDiagonalLength,
}
