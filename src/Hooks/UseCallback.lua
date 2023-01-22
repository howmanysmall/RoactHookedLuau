--!optimize 2
local UseMemo = require(script.Parent:FindFirstChild("UseMemo"))

local function UseCallback<T>(Callback: T, Dependencies: {unknown}?): T
	return UseMemo(function()
		return Callback
	end, Dependencies)
end

return UseCallback
