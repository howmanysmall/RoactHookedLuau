--!optimize 2
--!strict

local UseEffect = require(script.Parent.UseEffect)
local UseRef = require(script.Parent.UseRef)
local UseState = require(script.Parent.UseState)

local function UseObjectReference<T>(): ({current: T?}, T?)
	local reference = UseRef()
	local object: T?, setObject = UseState(nil :: T?)

	local function setObjectEffect()
		local rbx = reference.current
		if rbx then
			setObject(rbx)
		end
	end
	UseEffect(setObjectEffect, {})

	return reference, object
end

return UseObjectReference
