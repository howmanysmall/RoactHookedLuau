--!optimize 2
--!strict

local UseReducer = require(script.Parent.UseReducer)

local function Reducer(value: number)
	return (value + 1) % 1_000_000
end

local function UseForceUpdate(): () -> ()
	local _, forceUpdate = UseReducer(Reducer, 0)
	return forceUpdate :: never
end

return UseForceUpdate
