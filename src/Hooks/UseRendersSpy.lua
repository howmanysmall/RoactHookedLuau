--!optimize 2
--!strict

local UseEffect = require(script.Parent.UseEffect)
local UseMutable = require(script.Parent.UseMutable)

local function UseRendersSpy(): number
	local count = UseMutable(0)

	local function increment()
		count.Current += 1
	end
	UseEffect(increment, {})

	return count.Current
end

return UseRendersSpy
