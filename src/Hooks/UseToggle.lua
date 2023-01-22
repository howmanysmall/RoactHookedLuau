--!optimize 2
local GetDependencies = require(script.Parent:FindFirstChild("GetDependencies"))
local UseCallback = require(script.Parent:FindFirstChild("UseCallback"))
local UseState = require(script.Parent:FindFirstChild("UseState"))

local function UseToggle(InitialValue: boolean?): (boolean, () -> ())
	local Value, SetValue = UseState(not not InitialValue)
	local ToggleValue = UseCallback(function()
		SetValue(not Value)
	end, GetDependencies(Value))

	return Value, ToggleValue
end

return UseToggle
