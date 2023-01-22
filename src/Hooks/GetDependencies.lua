--!optimize 2
--!strict
local NilDependency = newproxy(true)
local Metatable = getmetatable(NilDependency)

function Metatable:__tostring()
	return "NilDependency"
end

local function GetDependencies(...)
	local Length = select("#", ...)
	local New = table.create(Length)

	for Index = 1, Length do
		local Dependency = select(Index, ...)
		New[Index] = if Dependency == nil then NilDependency else Dependency
	end

	return New
end

return GetDependencies
