--!optimize 2
local Roact = require(script.Parent.Parent:FindFirstChild("Roact"))
local Hooks = require(script.Parent:FindFirstChild("Hooks"))

local WithHooks = {}

export type IHookOptions<T> = {
	Api: {[any]: any}?,
	ComponentType: nil | "Component" | "PureComponent" | typeof(Roact.Component),
	DefaultProps: (T & {[any]: any})?,
	Name: string?,
	ValidateProps: nil | (props: (T & {[any]: any})?) -> (any, string?),
}

local function WithHooksImplementation<T>(Render: (props: T & {[any]: any}) -> any, Class, Options: IHookOptions<T>?)
	local TrueOptions: IHookOptions<T> = if Options then Options else {}
	local ComponentName = TrueOptions.Name or debug.info(Render, "n") or "GenericComponent"

	local ProxyComponent = Class:extend(ComponentName .. "Hooked")
	ProxyComponent.ComponentName = ComponentName

	ProxyComponent.didMount = Hooks.CommitHookEffectListUpdate
	ProxyComponent.didUpdate = Hooks.CommitHookEffectListUpdate
	ProxyComponent.willUnmount = Hooks.CommitHookEffectListUnmount

	function ProxyComponent:render()
		Hooks.PrepareToUseHooks(self)
		local children = Render(self.props)
		Hooks.FinishHooks()
		return children
	end

	ProxyComponent.defaultProps = TrueOptions.DefaultProps
	ProxyComponent.validateProps = TrueOptions.ValidateProps

	if TrueOptions.Api and type(TrueOptions.Api) == "table" then
		for Key, Value in TrueOptions.Api do
			ProxyComponent[Key] = Value
		end
	end

	return ProxyComponent
end

function WithHooks.WithHooks<T>(Render: (props: T & {[any]: any}) -> any, Options: IHookOptions<T>?)
	return WithHooksImplementation(Render, Roact.Component, Options)
end

function WithHooks.WithHooksPure<T>(Render: (props: T & {[any]: any}) -> any, Options: IHookOptions<T>?)
	return WithHooksImplementation(Render, Roact.PureComponent, Options)
end

function WithHooks.new(RoactImplementation)
	return function<T>(Render: (props: T & {[any]: any}) -> any, Options: IHookOptions<T>?)
		local TrueOptions: IHookOptions<T> = if Options then Options else {}
		local ComponentType = TrueOptions.ComponentType

		local ComponentClass
		if type(ComponentType) == "string" then
			ComponentClass = if ComponentType == "Component"
				then RoactImplementation.Component
				else RoactImplementation.PureComponent
		elseif type(ComponentType) == "table" then
			ComponentClass = ComponentType
		else
			ComponentClass = RoactImplementation.PureComponent
		end

		return WithHooksImplementation(Render, ComponentClass, TrueOptions)
	end
end

table.freeze(WithHooks)
return WithHooks
