--!nonstrict
--!optimize 2

local ThreadUtilities = require(script.Parent.Parent.Parent.ThreadUtilities)

local HookUtility = {}
HookUtility.CurrentlyRenderingComponent = nil :: any?
HookUtility.IsReRender = false

local hookCount = 0
local workInProgressHook

function HookUtility.FinishHooks()
	HookUtility.CurrentlyRenderingComponent = nil
	hookCount = 0
	workInProgressHook = nil
end

function HookUtility.PrepareToUseHooks(componentIdentity)
	if workInProgressHook ~= nil then
		local previous = workInProgressHook.ComponentName
		local current = componentIdentity.ComponentName
		warn(
			`The component '{previous}' did not finish rendering before '{current}'. Did the former yield or fail to run?`
		)

		HookUtility.CurrentlyRenderingComponent = nil
		hookCount = 0
		workInProgressHook = nil
	end

	HookUtility.CurrentlyRenderingComponent = componentIdentity
end

local function ResolveCurrentlyRenderingComponent()
	local currentlyRenderingComponent = HookUtility.CurrentlyRenderingComponent
	if not currentlyRenderingComponent then
		error(
			"Invalid hook call. Hooks can only be called inside of the body of a function component. This could happen for one of the following reasons:\n"
				.. "1. You might be using hooks outside of the WithHooks() HOC\n"
				.. "2. You might be breaking the Rules of Hooks\n"
				.. "3. A hooked component may have yielded or thrown an error\n"
		)
	end

	return currentlyRenderingComponent
end

HookUtility.ResolveCurrentlyRenderingComponent = ResolveCurrentlyRenderingComponent

local function AreHookInputsEqual(nextDependencies: any, previousDependencies: any)
	if not previousDependencies then
		return false
	end

	local typeOf = type(nextDependencies)
	if typeOf ~= type(previousDependencies) then
		return false
	end

	if typeOf == "table" then
		for key, value in nextDependencies do
			if previousDependencies[key] ~= value then
				return false
			end
		end

		for key, value in previousDependencies do
			if nextDependencies[key] ~= value then
				return false
			end
		end

		return true
	end

	return nextDependencies == previousDependencies
end

HookUtility.AreHookInputsEqual = AreHookInputsEqual

export type Hook = {
	Index: number,
	MemoizedState: {[any]: any},
	Next: {[any]: any},
}

function HookUtility.CreateHook()
	return {
		Index = hookCount;
		MemoizedState = nil;
		Next = nil;
	}
end

function HookUtility.CreateWorkInProgressHook()
	hookCount += 1

	if not workInProgressHook then
		local currentlyRenderingComponent = HookUtility.CurrentlyRenderingComponent

		if not currentlyRenderingComponent.FirstHook then
			HookUtility.IsReRender = false

			local hook = {
				Index = hookCount;
				MemoizedState = nil;
				Next = nil;
			}

			currentlyRenderingComponent.FirstHook = hook
			workInProgressHook = hook
		else
			HookUtility.IsReRender = true
			workInProgressHook = currentlyRenderingComponent.FirstHook
		end
	else
		if not workInProgressHook.Next then
			HookUtility.IsReRender = false

			local hook = {
				Index = hookCount;
				MemoizedState = nil;
				Next = nil;
			}

			workInProgressHook.Next = hook
			workInProgressHook = hook
		else
			HookUtility.IsReRender = true
			workInProgressHook = workInProgressHook.Next
		end
	end

	return workInProgressHook
end

function HookUtility.CommitHookEffectListUpdate(componentIdentity)
	local lastEffect = componentIdentity.LastEffect
	if not lastEffect then
		return
	end

	local firstEffect = lastEffect.Next
	local effect = firstEffect

	repeat
		local previousDependencies = effect.PreviousDependencies
		if previousDependencies and AreHookInputsEqual(effect.Dependencies, previousDependencies) then
			-- Nothing changed
			effect = effect.Next
			continue
		end

		-- Clear
		local destroy = effect.Destroy
		effect.Destroy = nil

		if destroy then
			ThreadUtilities.FastSpawn(destroy)
		end

		-- Update
		ThreadUtilities.FastSpawn(function()
			effect.Destroy = effect.Create()
		end)

		effect = effect.Next
	until effect == firstEffect
end

function HookUtility.CommitHookEffectListUnmount(componentIdentity)
	local lastEffect = componentIdentity.LastEffect
	if not lastEffect then
		return
	end

	local firstEffect = lastEffect.Next
	local effect = firstEffect

	repeat
		-- Clear
		local destroy = effect.Destroy
		effect.Destroy = nil

		if destroy then
			ThreadUtilities.FastSpawn(destroy)
		end

		effect = effect.Next
	until effect == firstEffect
end

function HookUtility.PushEffect(create, destroy, dependencies)
	ResolveCurrentlyRenderingComponent()
	local effect = {
		Create = create;
		Dependencies = dependencies;
		Destroy = destroy;
		Next = nil;
		PreviousDependencies = nil;
	}

	local currentlyRenderingComponent = HookUtility.CurrentlyRenderingComponent
	local lastEffect = currentlyRenderingComponent.LastEffect

	if lastEffect then
		local firstEffect = lastEffect.Next
		lastEffect.Next = effect
		effect.Next = firstEffect
		currentlyRenderingComponent.LastEffect = effect
	else
		effect.Next = effect
		currentlyRenderingComponent.LastEffect = effect
	end

	return effect
end

function HookUtility.BasicStateReducer(state, action)
	if type(action) == "function" then
		return action(state)
	end
	return action
end

return HookUtility
