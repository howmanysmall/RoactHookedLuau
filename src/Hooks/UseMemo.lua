--!optimize 2
--!strict

--# selene: allow(mixed_table)

local HookUtility = require(script.Parent.HookUtility)

local function Pack<T...>(...: T...)
	return {
		n = select("#", ...);
		select(1, ...);
	}
end

local function UseMemo<T...>(create: () -> T..., dependencies: {unknown}?): T...
	HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()
	local previousState = hook.MemoizedState

	if
		previousState ~= nil
		and dependencies ~= nil
		and HookUtility.AreHookInputsEqual(dependencies, previousState.Dependencies)
	then
		local value = previousState.Value
		return table.unpack(value, 1, value.n)
	end

	local values = Pack(create())
	hook.MemoizedState = {
		Dependencies = dependencies;
		Value = values;
	}

	return table.unpack(values, 1, values.n)
end

return UseMemo
