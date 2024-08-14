--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)
local UseReducer = require(script.Parent.UseReducer)

local function UseState<S>(initialState: S | (() -> S)): (S, (((S) -> S) | S) -> ())
	return UseReducer(
		HookUtility.BasicStateReducer,
		if type(initialState) == "function" then initialState() else initialState
	)
end

return UseState
