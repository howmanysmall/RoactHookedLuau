--!optimize 2
local GetDependencies = require(script:FindFirstChild("GetDependencies"))
local HookUtility = require(script:FindFirstChild("HookUtility"))

local UseBinding = require(script:FindFirstChild("UseBinding"))
local UseCallback = require(script:FindFirstChild("UseCallback"))
local UseContext = require(script:FindFirstChild("UseContext"))
local UseEffect = require(script:FindFirstChild("UseEffect"))
local UseMemo = require(script:FindFirstChild("UseMemo"))
local UseReducer = require(script:FindFirstChild("UseReducer"))
local UseState = require(script:FindFirstChild("UseState"))
local UseMutable = require(script:FindFirstChild("UseMutable"))
local UseRef = require(script:FindFirstChild("UseRef"))

local UseForceUpdate = require(script:FindFirstChild("UseForceUpdate"))
local UseMemoCompare = require(script:FindFirstChild("UseMemoCompare"))
local UseRendersSpy = require(script:FindFirstChild("UseRendersSpy"))
local UseToggle = require(script:FindFirstChild("UseToggle"))

local Hooks = {
	GetDependencies = GetDependencies,

	UseBinding = UseBinding,
	UseCallback = UseCallback,
	UseContext = UseContext,
	UseEffect = UseEffect,
	UseMemo = UseMemo,
	UseReducer = UseReducer,
	UseState = UseState,
	UseMutable = UseMutable,
	UseRef = UseRef,

	UseForceUpdate = UseForceUpdate,
	UseMemoCompare = UseMemoCompare,
	UseRendersSpy = UseRendersSpy,
	UseToggle = UseToggle,

	CommitHookEffectListUpdate = HookUtility.CommitHookEffectListUpdate,
	CommitHookEffectListUnmount = HookUtility.CommitHookEffectListUnmount,
	PrepareToUseHooks = HookUtility.PrepareToUseHooks,
	FinishHooks = HookUtility.FinishHooks,
}

table.freeze(Hooks)
return Hooks
