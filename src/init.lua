--!optimize 2
local Hooks = require(script:FindFirstChild("Hooks"))
local WithHooks = require(script:FindFirstChild("WithHooks"))

local RoactHooked = {}
RoactHooked.GetDependencies = Hooks.GetDependencies

RoactHooked.UseBinding = Hooks.UseBinding
RoactHooked.UseCallback = Hooks.UseCallback
RoactHooked.UseContext = Hooks.UseContext
RoactHooked.UseEffect = Hooks.UseEffect
RoactHooked.UseMemo = Hooks.UseMemo
RoactHooked.UseReducer = Hooks.UseReducer
RoactHooked.UseState = Hooks.UseState
RoactHooked.UseMutable = Hooks.UseMutable
RoactHooked.UseRef = Hooks.UseRef

RoactHooked.UseForceUpdate = Hooks.UseForceUpdate
RoactHooked.UseMemoCompare = Hooks.UseMemoCompare
RoactHooked.UseRendersSpy = Hooks.UseRendersSpy
RoactHooked.UseToggle = Hooks.UseToggle

RoactHooked.Hook = WithHooks.WithHooks
RoactHooked.HookPure = WithHooks.WithHooksPure
RoactHooked.new = WithHooks.new

export type IHookOptions<T> = WithHooks.IHookOptions<T>

table.freeze(RoactHooked)
return RoactHooked
