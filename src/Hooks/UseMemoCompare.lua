--!optimize 2
local UseEffect = require(script.Parent:FindFirstChild("UseEffect"))
local UseMutable = require(script.Parent:FindFirstChild("UseMutable"))

local function UseMemoCompare<T>(Next: T, Compare: (Previous: T, Next: T) -> boolean)
	local PreviousValue = UseMutable(nil :: T?)
	local Previous = PreviousValue.Current

	local IsEqual = Compare(Previous, Next)
	UseEffect(function()
		if not IsEqual then
			PreviousValue.Current = Next
		end
	end, {})

	return if IsEqual then Previous else Next
end

return UseMemoCompare
