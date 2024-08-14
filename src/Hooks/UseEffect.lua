--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)

type Effect = () -> ()
type EffectWithCleanup = () -> Effect
type EffectFunction = Effect | EffectWithCleanup

local function UseEffect(callback: (() -> () -> ()) | (() -> ()), dependencies: {unknown}?)
	HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()

	if not HookUtility.IsReRender then
		hook.MemoizedState = HookUtility.PushEffect(callback, nil, dependencies)
	else
		local memoizedState = hook.MemoizedState
		memoizedState.PreviousDependencies = memoizedState.Dependencies
		memoizedState.Dependencies = dependencies
		memoizedState.Create = callback
	end
end

return UseEffect
