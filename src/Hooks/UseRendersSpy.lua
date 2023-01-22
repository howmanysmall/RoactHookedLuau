--!optimize 2
local UseEffect = require(script.Parent:FindFirstChild("UseEffect"))
local UseMutable = require(script.Parent:FindFirstChild("UseMutable"))

local function UseRendersSpy(): number
	local Count = UseMutable(0)
	UseEffect(function()
		Count.Current += 1
	end, {})

	return Count.Current
end

return UseRendersSpy
