--!optimize 2
--!strict

local GetDependencies = require(script.GetDependencies)
local HookUtility = require(script.HookUtility)

local UseAsyncEffect = require(script.UseAsyncEffect)
local UseBinding = require(script.UseBinding)
local UseCallback = require(script.UseCallback)
local UseContext = require(script.UseContext)
local UseCurrentCamera = require(script.UseCurrentCamera)
local UseDeepCompare = require(script.UseDeepCompare)
local UseEffect = require(script.UseEffect)
local UseEventConnection = require(script.UseEventConnection)
local UseForceUpdate = require(script.UseForceUpdate)
local UseMemo = require(script.UseMemo)
local UseMutable = require(script.UseMutable)
local UseObjectReference = require(script.UseObjectReference)
local UseReducer = require(script.UseReducer)
local UseRef = require(script.UseRef)
local UseRendersSpy = require(script.UseRendersSpy)
local UseSingularMemo = require(script.UseSingularMemo)
local UseState = require(script.UseState)
local UseToggle = require(script.UseToggle)
local UseViewportSize = require(script.UseViewportSize)

local Hooks = table.freeze({
	GetDependencies = GetDependencies;

	UseAsyncEffect = UseAsyncEffect;
	UseBinding = UseBinding;
	UseCallback = UseCallback;
	UseContext = UseContext;
	UseCurrentCamera = UseCurrentCamera;
	UseDeepCompare = UseDeepCompare;
	UseEffect = UseEffect;
	UseEventConnection = UseEventConnection;
	UseForceUpdate = UseForceUpdate;
	UseMemo = UseMemo;
	UseMutable = UseMutable;
	UseObjectReference = UseObjectReference;
	UseReducer = UseReducer;
	UseRef = UseRef;
	UseRendersSpy = UseRendersSpy;
	UseSingularMemo = UseSingularMemo;
	UseState = UseState;
	UseToggle = UseToggle;
	UseViewportSize = UseViewportSize;

	CommitHookEffectListUpdate = HookUtility.CommitHookEffectListUpdate;
	CommitHookEffectListUnmount = HookUtility.CommitHookEffectListUnmount;
	PrepareToUseHooks = HookUtility.PrepareToUseHooks;
	FinishHooks = HookUtility.FinishHooks;
})

return Hooks
