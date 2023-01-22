--!optimize 2
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))

local function UseMutable<T>(InitialValue: T): {Current: T}
	HookUtility.ResolveCurrentlyRenderingComponent()
	local Hook = HookUtility.CreateWorkInProgressHook()
	local MemoizedState = Hook.MemoizedState

	if not HookUtility.IsReRender then
		MemoizedState = {Current = InitialValue}
		Hook.MemoizedState = MemoizedState
	end

	return MemoizedState :: {Current: T}
end

return UseMutable
