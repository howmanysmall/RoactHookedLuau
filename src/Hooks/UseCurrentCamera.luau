--!optimize 2
--!strict

local Workspace = game:GetService("Workspace")
local UseEventConnection = require(script.Parent.UseEventConnection)
local UseState = require(script.Parent.UseState)

local function UseCurrentCamera(): Camera
	local currentCamera: Camera, setCurrentCamera = UseState(Workspace.CurrentCamera)
	UseEventConnection(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
		if Workspace.CurrentCamera then
			setCurrentCamera(Workspace.CurrentCamera)
		end
	end, {})

	return currentCamera
end

return UseCurrentCamera
