--!optimize 2
--!strict

local NilDependency = newproxy(true)
local Metatable = getmetatable(NilDependency)

function Metatable:__tostring()
	return "NilDependency"
end

local function GetDependencies(...: unknown)
	local length = select("#", ...)
	local array = table.create(length)

	for index = 1, length do
		local dependency = select(index, ...)
		array[index] = if dependency == nil then NilDependency else dependency
	end

	return array
end

return GetDependencies
