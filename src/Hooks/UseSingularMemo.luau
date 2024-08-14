--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)

local function UseSingularMemo<T>(create: () -> T, dependencies: {unknown}?): T
	HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()
	local previousState = hook.MemoizedState

	if
		previousState ~= nil
		and dependencies ~= nil
		and HookUtility.AreHookInputsEqual(dependencies, previousState.Dependencies)
	then
		return previousState.Value
	end

	local value = create()
	hook.MemoizedState = {
		Dependencies = dependencies;
		Value = value;
	}

	return value
end

return UseSingularMemo
