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
	UseCurrentCamera = Hooks.UseCurrentCamera;
	UseDeepCompare = Hooks.UseDeepCompare;
	UseEffect = Hooks.UseEffect;
	UseEventConnection = Hooks.UseEventConnection;
	UseForceUpdate = Hooks.UseForceUpdate;
	UseMemo = Hooks.UseMemo;
	UseMutable = Hooks.UseMutable;
	UseObjectReference = Hooks.UseObjectReference;
	UseReducer = Hooks.UseReducer;
	UseRef = Hooks.UseRef;
	UseRendersSpy = Hooks.UseRendersSpy;
	UseSingularMemo = Hooks.UseSingularMemo;
	UseState = Hooks.UseState;
	UseToggle = Hooks.UseToggle;
	UseViewportSize = Hooks.UseViewportSize;

	Hook = WithHooks.WithHooks;
	HookPure = WithHooks.WithHooksPure;
	new = WithHooks.new;
})

export type HookOptions<T> = WithHooks.HookOptions<T>
export type RoactBinding<T> = Types.RoactBinding<T>
export type RoactBindingUpdater<T> = Types.RoactBindingUpdater<T>

return RoactHooked
