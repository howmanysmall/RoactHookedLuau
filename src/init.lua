--!optimize 2
--!strict

local Hooks = require(script.Hooks)
local Types = require(script.Types)
local WithHooks = require(script.WithHooks)

local RoactHooked = table.freeze({
	GetDependencies = Hooks.GetDependencies;

	UseBinding = Hooks.UseBinding;
	UseCallback = Hooks.UseCallback;
	UseContext = Hooks.UseContext;
	UseEffect = Hooks.UseEffect;
	UseForceUpdate = Hooks.UseForceUpdate;
	UseMemo = Hooks.UseMemo;
	UseMutable = Hooks.UseMutable;
	UseReducer = Hooks.UseReducer;
	UseRef = Hooks.UseRef;
	UseRendersSpy = Hooks.UseRendersSpy;
	UseState = Hooks.UseState;
	UseToggle = Hooks.UseToggle;

	Hook = WithHooks.WithHooks;
	HookPure = WithHooks.WithHooksPure;
	new = WithHooks.new;
})

export type HookOptions<T> = WithHooks.HookOptions<T>

export type RoactBinding<T> = Types.RoactBinding<T>
export type RoactBindingUpdater<T> = Types.RoactBindingUpdater<T>

return RoactHooked
