--!optimize 2
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))

type Effect = () -> ()
type EffectWithCleanup = () -> Effect
type EffectFunction = Effect | EffectWithCleanup

local function UseEffect(Callback: EffectFunction, Dependencies: {unknown}?)
	HookUtility.ResolveCurrentlyRenderingComponent()
	local Hook = HookUtility.CreateWorkInProgressHook()

	if not HookUtility.IsReRender then
		Hook.MemoizedState = HookUtility.PushEffect(Callback, nil, Dependencies)
	else
		local MemoizedState = Hook.MemoizedState
		MemoizedState.PreviousDependencies = MemoizedState.Dependencies
		MemoizedState.Dependencies = Dependencies
		MemoizedState.Create = Callback
	end
end

return UseEffect
