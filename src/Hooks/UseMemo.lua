--!optimize 2
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))

local function UseMemo<T>(Factory: () -> T, Dependencies: {unknown}?): T
	HookUtility.ResolveCurrentlyRenderingComponent()
	local Hook = HookUtility.CreateWorkInProgressHook()
	local PreviousState = Hook.MemoizedState

	if
		PreviousState ~= nil
		and Dependencies ~= nil
		and HookUtility.AreHookInputsEqual(Dependencies, PreviousState.Dependencies)
	then
		return PreviousState.Value
	end

	local Value = Factory()
	Hook.MemoizedState = {
		Dependencies = Dependencies,
		Value = Value,
	}

	return Value
end

return UseMemo
