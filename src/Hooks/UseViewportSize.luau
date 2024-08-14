--!optimize 2
--!strict

local UseBinding = require(script.Parent.UseBinding)
local UseCurrentCamera = require(script.Parent.UseCurrentCamera)
local UseEffect = require(script.Parent.UseEffect)

local function UseViewportSize(): UseBinding.Binding<Vector2>
	local currentCamera = UseCurrentCamera()
	local viewportSize, setViewportSize = UseBinding(if currentCamera then currentCamera.ViewportSize else Vector2.zero)

	local function viewportSizeEffect()
		if not currentCamera then
			return
		end

		setViewportSize(currentCamera.ViewportSize)
		local connection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			setViewportSize(currentCamera.ViewportSize)
		end)

		return function()
			connection:Disconnect()
		end
	end
	UseEffect(viewportSizeEffect, {currentCamera})

	return viewportSize
end

return UseViewportSize
