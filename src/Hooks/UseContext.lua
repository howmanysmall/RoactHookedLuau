--!optimize 2
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))
local UseEffect = require(script.Parent:FindFirstChild("UseEffect"))
local UseState = require(script.Parent:FindFirstChild("UseState"))

local function UseContext(Context)
	HookUtility.ResolveCurrentlyRenderingComponent()
	local Hook = HookUtility.CreateWorkInProgressHook()

	local ContextEntry = Hook.MemoizedState

	if not HookUtility.IsReRender then
		local Consumer = setmetatable({}, {__index = HookUtility.CurrentlyRenderingComponent})
		Context.Consumer.init(Consumer)
		ContextEntry = Consumer.contextEntry
		Hook.MemoizedState = ContextEntry
	end

	local Value, SetValue = UseState(ContextEntry and ContextEntry.value)
	UseEffect(function()
		return ContextEntry.onUpdate:subscribe(SetValue)
	end, {})

	return Value
end

return UseContext
