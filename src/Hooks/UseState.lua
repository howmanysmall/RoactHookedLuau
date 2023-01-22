--!optimize 2
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))
local UseReducer = require(script.Parent:FindFirstChild("UseReducer"))

local function UseState<T>(InitialState: T): (T, (NewValue: T | <V>(CurrentState: V) -> T) -> ())
	return UseReducer(HookUtility.BasicStateReducer, InitialState)
end

return UseState
