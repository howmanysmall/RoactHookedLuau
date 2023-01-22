--!optimize 2
local Roact = require(script.Parent.Parent.Parent:FindFirstChild("Roact"))
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))
local Types = require(script.Parent.Parent:FindFirstChild("Types"))

type RoactBinding<T> = Types.RoactBinding<T>

local function UseBinding<T>(InitialValue: T): (RoactBinding<T>, (NewValue: T) -> ())
	HookUtility.ResolveCurrentlyRenderingComponent()
	local Hook = HookUtility.CreateWorkInProgressHook()
	local MemoizedState = Hook.MemoizedState

	if not HookUtility.IsReRender then
		local Binding, SetValue = Roact.createBinding(InitialValue)
		MemoizedState = {
			Binding = Binding,
			SetValue = SetValue,
		}

		Hook.MemoizedState = MemoizedState
	end

	return MemoizedState.Binding, MemoizedState.SetValue
end

return UseBinding
