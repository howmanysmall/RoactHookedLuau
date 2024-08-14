--!optimize 2

local Roact = require(script.Parent.Parent.Roact)
local Hooks = require(script.Parent.Hooks)

local WithHooks = {}

export type HookOptions<T> = {
	Api: {[any]: any}?,
	ComponentType: nil | "Component" | "PureComponent" | typeof(Roact.Component),
	DefaultProperties: T?,
	Name: string?,
	ValidateProperties: nil | (properties: T?) -> (any, string?),
}

local function WithHooksImplementation<T>(render: (properties: T) -> any, roactComponentClass, options: HookOptions<T>?)
	local trueOptions: HookOptions<T> = options or {}
	local componentName = trueOptions.Name or debug.info(render, "n") or "GenericComponent"

	local proxyComponent = roactComponentClass:extend(`{componentName}Hooked`)
	proxyComponent.ComponentName = componentName

	proxyComponent.didMount = Hooks.CommitHookEffectListUpdate
	proxyComponent.didUpdate = Hooks.CommitHookEffectListUpdate
	proxyComponent.willUnmount = Hooks.CommitHookEffectListUnmount

	function proxyComponent:render()
		Hooks.PrepareToUseHooks(self)
		local children = render(self.props)
		Hooks.FinishHooks()
		return children
	end

	proxyComponent.defaultProps = trueOptions.DefaultProperties
	proxyComponent.validateProps = trueOptions.ValidateProperties

	if trueOptions.Api and type(trueOptions.Api) == "table" then
		for key, value in trueOptions.Api do
			proxyComponent[key] = value
		end
	end

	return proxyComponent
end

function WithHooks.WithHooks<T>(render: (properties: T) -> any, options: HookOptions<T>?)
	return WithHooksImplementation(render, Roact.Component, options)
end

function WithHooks.WithHooksPure<T>(render: (properties: T) -> any, options: HookOptions<T>?)
	return WithHooksImplementation(render, Roact.PureComponent, options)
end

function WithHooks.new(roactImplementation)
	return function<T>(render: (properties: T) -> any, options: HookOptions<T>?)
		local trueOptions: HookOptions<T> = options or {}
		local componentType = trueOptions.ComponentType

		local componentClass
		if type(componentType) == "string" then
			componentClass = if componentType == "Component"
				then roactImplementation.Component
				else roactImplementation.PureComponent
		elseif type(componentType) == "table" then
			componentClass = componentType
		else
			componentClass = roactImplementation.PureComponent
		end

		return WithHooksImplementation(render, componentClass, trueOptions)
	end
end

return table.freeze(WithHooks)
