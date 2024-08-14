--!optimize 2
--!strict

local UseMemo = require(script.Parent.UseMemo)

local function UseCallback<T>(callback: T, dependencies: {unknown}?): T
	return UseMemo(function()
		return callback
	end, dependencies)
end

return UseCallback
