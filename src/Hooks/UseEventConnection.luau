--!optimize 2
--!strict

local UseEffect = require(script.Parent.UseEffect)
local UseMemo = require(script.Parent.UseMemo)

type ConnectionLike = {
	Disconnect: (self: ConnectionLike) -> (),
	[any]: any,
}
type SignalLike<T...> = {
	Connect: (self: SignalLike<T...>, callback: (T...) -> ()) -> ConnectionLike,
	[any]: any,
}

local function UseEventConnection<T...>(event: RBXScriptSignal<T...>, callback: (T...) -> (), dependencies: {unknown})
	local cachedCallback = UseMemo(function()
		return callback
	end, dependencies)

	local function connectEffect()
		local connection = event:Connect(cachedCallback)

		return function()
			connection:Disconnect()
		end
	end
	UseEffect(connectEffect, {event, cachedCallback} :: {unknown})
end

type UseRbxEventConnection = <T...>(event: RBXScriptSignal<T...>, callback: (T...) -> (), dependencies: {unknown}) -> ()
type UseSignalEventConnection = <T...>(event: SignalLike<T...>, callback: (T...) -> (), dependencies: {unknown}) -> ()

return UseEventConnection :: UseRbxEventConnection & UseSignalEventConnection
