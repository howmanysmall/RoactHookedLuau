--!optimize 2
--!strict

local UseCallback = require(script.Parent.UseCallback)
local UseState = require(script.Parent.UseState)

local function Invert(value: boolean): boolean
	return not value
end

local function UseToggle(initialValue: boolean?): (boolean, () -> ())
	local value, setValue = UseState(not not initialValue)
	local toggleValue = UseCallback(function()
		setValue(Invert)
	end, {})

	return value, toggleValue
end

return UseToggle
