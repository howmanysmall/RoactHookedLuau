--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)
local UseEffect = require(script.Parent.UseEffect)
local UseState = require(script.Parent.UseState)

local function UseContext(context)
	HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()

	local contextEntry = hook.MemoizedState

	if not HookUtility.IsReRender then
		local consumer = setmetatable({}, {__index = HookUtility.CurrentlyRenderingComponent})
		context.Consumer.init(consumer)
		contextEntry = consumer.contextEntry
		hook.MemoizedState = contextEntry
	end

	local value, setValue = UseState(contextEntry and contextEntry.value)

	local function subscribeEffect()
		return contextEntry.onUpdate:subscribe(setValue)
	end
	UseEffect(subscribeEffect, {})

	return value
end

return UseContext
