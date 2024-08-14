--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)
local Roact = require(script.Parent.Parent.Parent.Roact)

local function UseRef()
	HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()
	local memoizedState = hook.MemoizedState

	if not HookUtility.IsReRender then
		memoizedState = Roact.createRef()
		hook.MemoizedState = memoizedState
	end

	return memoizedState
end

return UseRef
