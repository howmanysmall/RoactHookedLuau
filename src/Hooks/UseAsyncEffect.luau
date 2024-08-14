--!optimize 2
--!strict

local Promise = require(script.Parent.Parent.Parent.Promise)
local UseEffect = require(script.Parent.UseEffect)
local UseMemo = require(script.Parent.UseMemo)

local function UseAsyncEffect<T...>(getPromise: () -> Promise.TypedPromise<T...>, dependencies: {unknown}?)
	local cachedGetter = UseMemo(function()
		return getPromise
	end, dependencies)

	local function asyncEffect()
		local promise = cachedGetter()
		return function()
			promise:cancel()
		end
	end
	UseEffect(asyncEffect, {cachedGetter})
end

return UseAsyncEffect
