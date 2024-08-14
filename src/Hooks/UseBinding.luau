--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)
local Roact = require(script.Parent.Parent.Parent.Roact)
local Types = require(script.Parent.Parent.Types)

export type Binding<T> = Types.CoreRoactBinding<T> & Types.RoactBindingMap

local function UseBinding<T>(initialValue: T): (Types.CoreRoactBinding<T> & Types.RoactBindingMap, (newValue: T) -> ())
	HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()
	local memoizedState = hook.MemoizedState

	if not HookUtility.IsReRender then
		local binding, setBinding = Roact.createBinding(initialValue)
		memoizedState = {
			Binding = binding,
			SetValue = setBinding,
		}

		hook.MemoizedState = memoizedState
	end

	return memoizedState.Binding, memoizedState.SetValue
end

return UseBinding
