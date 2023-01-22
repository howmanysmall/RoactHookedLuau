--!optimize 2
local Roact = require(script.Parent.Parent.Parent:FindFirstChild("Roact"))
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))

local function UseRef()
	HookUtility.ResolveCurrentlyRenderingComponent()
	local Hook = HookUtility.CreateWorkInProgressHook()
	local MemoizedState = Hook.MemoizedState

	if not HookUtility.IsReRender then
		MemoizedState = Roact.createRef()
		Hook.MemoizedState = MemoizedState
	end

	return MemoizedState
end

return UseRef
