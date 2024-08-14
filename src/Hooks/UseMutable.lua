--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)

local function UseMutable<T>(initialValue: T): {Current: T}
	HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()
	local memoizedState = hook.MemoizedState

	if not HookUtility.IsReRender then
		memoizedState = {Current = initialValue}
		hook.MemoizedState = memoizedState
	end

	return memoizedState :: {Current: T}
end

return UseMutable
