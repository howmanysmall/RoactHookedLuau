--!optimize 2
--!strict

local GetDependencies = require(script.GetDependencies)
local HookUtility = require(script.HookUtility)

local UseBinding = require(script.UseBinding)
local UseCallback = require(script.UseCallback)
local UseContext = require(script.UseContext)
local UseEffect = require(script.UseEffect)
local UseForceUpdate = require(script.UseForceUpdate)
local UseMemo = require(script.UseMemo)
local UseMutable = require(script.UseMutable)
local UseReducer = require(script.UseReducer)
local UseRef = require(script.UseRef)
local UseRendersSpy = require(script.UseRendersSpy)
local UseState = require(script.UseState)
local UseToggle = require(script.UseToggle)

local Hooks = table.freeze({
	GetDependencies = GetDependencies;

	UseBinding = UseBinding;
	UseCallback = UseCallback;
	UseContext = UseContext;
	UseEffect = UseEffect;
	UseForceUpdate = UseForceUpdate;
	UseMemo = UseMemo;
	UseMutable = UseMutable;
	UseReducer = UseReducer;
	UseRef = UseRef;
	UseRendersSpy = UseRendersSpy;
	UseState = UseState;
	UseToggle = UseToggle;

	CommitHookEffectListUpdate = HookUtility.CommitHookEffectListUpdate;
	CommitHookEffectListUnmount = HookUtility.CommitHookEffectListUnmount;
	PrepareToUseHooks = HookUtility.PrepareToUseHooks;
	FinishHooks = HookUtility.FinishHooks;
})

return Hooks
