--!optimize 2
local HookUtility = {}
HookUtility.CurrentlyRenderingComponent = nil
HookUtility.IsReRender = false

local HookCount = 0
local WorkInProgressHook

function HookUtility.FinishHooks()
	HookUtility.CurrentlyRenderingComponent = nil
	HookCount = 0
	WorkInProgressHook = nil
end

function HookUtility.PrepareToUseHooks(ComponentIdentity)
	if WorkInProgressHook ~= nil then
		local Previous = WorkInProgressHook.ComponentName
		local Current = ComponentIdentity.ComponentName
		warn(
			"The component '"
				.. Previous
				.. "' did not finish rendering before '"
				.. Current
				.. "'. Did the former yield or fail to run?"
		)

		HookUtility.CurrentlyRenderingComponent = nil
		HookCount = 0
		WorkInProgressHook = nil
	end

	HookUtility.CurrentlyRenderingComponent = ComponentIdentity
end

local function ResolveCurrentlyRenderingComponent()
	local CurrentlyRenderingComponent = HookUtility.CurrentlyRenderingComponent
	if not CurrentlyRenderingComponent then
		error(
			"Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n"
				.. "1. You might be using hooks outside of the WithHooks() HOC\n"
				.. "2. You might be breaking the Rules of Hooks\n"
				.. "3. A hooked component may have yielded or thrown an error\n"
		)
	end

	return CurrentlyRenderingComponent
end

HookUtility.ResolveCurrentlyRenderingComponent = ResolveCurrentlyRenderingComponent

local function AreHookInputsEqual(NextDependencies, PreviousDependencies)
	if not PreviousDependencies then
		return false
	end

	local TypeOf = type(NextDependencies)
	if TypeOf ~= type(PreviousDependencies) then
		return false
	end

	if TypeOf == "table" then
		for Key, Value in NextDependencies do
			if PreviousDependencies[Key] ~= Value then
				return false
			end
		end

		for Key, Value in PreviousDependencies do
			if NextDependencies[Key] ~= Value then
				return false
			end
		end

		return true
	end

	return NextDependencies == PreviousDependencies
end

HookUtility.AreHookInputsEqual = AreHookInputsEqual

export type IHook = {
	Index: number,
	MemoizedState: {[any]: any},
	Next: {[any]: any},
}

function HookUtility.CreateHook()
	return {
		Index = HookCount,
		MemoizedState = nil,
		Next = nil,
	}
end

function HookUtility.CreateWorkInProgressHook()
	HookCount += 1

	if not WorkInProgressHook then
		local CurrentlyRenderingComponent = HookUtility.CurrentlyRenderingComponent

		if not CurrentlyRenderingComponent.FirstHook then
			HookUtility.IsReRender = false

			local Hook = {
				Index = HookCount,
				MemoizedState = nil,
				Next = nil,
			}

			CurrentlyRenderingComponent.FirstHook = Hook
			WorkInProgressHook = Hook
		else
			HookUtility.IsReRender = true
			WorkInProgressHook = CurrentlyRenderingComponent.FirstHook
		end
	else
		if not WorkInProgressHook.Next then
			HookUtility.IsReRender = false

			local Hook = {
				Index = HookCount,
				MemoizedState = nil,
				Next = nil,
			}

			WorkInProgressHook.Next = Hook
			WorkInProgressHook = Hook
		else
			HookUtility.IsReRender = true
			WorkInProgressHook = WorkInProgressHook.Next
		end
	end

	return WorkInProgressHook
end

function HookUtility.CommitHookEffectListUpdate(ComponentIdentity)
	local LastEffect = ComponentIdentity.LastEffect
	if not LastEffect then
		return
	end

	local FirstEffect = LastEffect.Next
	local Effect = FirstEffect

	repeat
		local PreviousDependencies = Effect.PreviousDependencies
		if PreviousDependencies and AreHookInputsEqual(Effect.Dependencies, PreviousDependencies) then
			-- Nothing changed
			Effect = Effect.Next
			continue
		end

		-- Clear
		local Destroy = Effect.Destroy
		Effect.Destroy = nil

		if Destroy then
			task.spawn(Destroy)
		end

		-- Update
		task.spawn(function()
			Effect.Destroy = Effect.Create()
		end)

		Effect = Effect.Next
	until Effect == FirstEffect
end

function HookUtility.CommitHookEffectListUnmount(ComponentIdentity)
	local LastEffect = ComponentIdentity.LastEffect
	if not LastEffect then
		return
	end

	local FirstEffect = LastEffect.Next
	local Effect = FirstEffect

	repeat
		-- Clear
		local Destroy = Effect.Destroy
		Effect.Destroy = nil

		if Destroy then
			task.spawn(Destroy)
		end

		Effect = Effect.Next
	until Effect == FirstEffect
end

function HookUtility.PushEffect(Create, Destroy, Dependencies)
	ResolveCurrentlyRenderingComponent()
	local Effect = {
		Create = Create,
		Dependencies = Dependencies,
		Destroy = Destroy,
		Next = nil,
		PreviousDependencies = nil,
	}

	local CurrentlyRenderingComponent = HookUtility.CurrentlyRenderingComponent
	local LastEffect = CurrentlyRenderingComponent.LastEffect

	if LastEffect then
		local FirstEffect = LastEffect.Next
		LastEffect.Next = Effect
		Effect.Next = FirstEffect
		CurrentlyRenderingComponent.LastEffect = Effect
	else
		Effect.Next = Effect
		CurrentlyRenderingComponent.LastEffect = Effect
	end

	return Effect
end

function HookUtility.BasicStateReducer(State, Action)
	if type(Action) == "function" then
		return Action(State)
	else
		return Action
	end
end

return HookUtility
