--!optimize 2
--!strict

local Sift = require(script.Parent.Parent.Parent.Sift)
local UseMutable = require(script.Parent.UseMutable)

local Sift_Dictionary_equalsDeep = Sift.Dictionary.equalsDeep

local function DeepCompare(previousValue: {unknown}?, currentValue: {unknown}?)
	if not previousValue or not currentValue then
		return false
	end

	if previousValue == currentValue then
		return true
	end

	local length = #previousValue
	if length ~= #currentValue then
		return false
	end

	for index = 1, length do
		if not Sift_Dictionary_equalsDeep(previousValue[index] :: never, currentValue[index]) then
			return false
		end
	end

	return true
end

local function UseDeepCompare(dependencies: {unknown})
	local reference = UseMutable({} :: {unknown})
	local updatedReference = UseMutable(0)

	if not DeepCompare(reference.Current, dependencies) then
		reference.Current = dependencies
		updatedReference.Current += 1
	end

	return {updatedReference.Current}
end

return UseDeepCompare
