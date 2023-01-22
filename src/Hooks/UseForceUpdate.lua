--!optimize 2
local UseReducer = require(script.Parent:FindFirstChild("UseReducer"))

local function Reducer(Value: number)
	return (Value + 1) % 1000000
end

local function UseForceUpdate(): () -> ()
	local _, ForceUpdate = UseReducer(Reducer, 0)
	return ForceUpdate
end

return UseForceUpdate
