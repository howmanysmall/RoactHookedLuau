--!optimize 2
local HookUtility = require(script.Parent:FindFirstChild("HookUtility"))

local function UseReducer(Reducer, InitialArgument, Initialize)
	local Component = HookUtility.ResolveCurrentlyRenderingComponent()
	local Hook = HookUtility.CreateWorkInProgressHook()
	local MemoizedState = Hook.MemoizedState

	if not HookUtility.IsReRender then
		local InitialState
		if Reducer == HookUtility.BasicStateReducer then
			if type(InitialArgument) == "function" then
				InitialState = InitialArgument()
			else
				InitialState = InitialArgument
			end
		else
			if Initialize then
				InitialState = Initialize(InitialArgument)
			else
				InitialState = InitialArgument
			end
		end

		local function Dispatch(Action)
			local PreviousState = MemoizedState.State
			local NextState = Reducer(PreviousState, Action)
			if NextState == PreviousState then
				return
			end

			MemoizedState.State = NextState
			Component:setState({
				[Hook.Index] = NextState,
			})

			return NextState
		end

		MemoizedState = {
			Dispatch = Dispatch,
			State = InitialState,
		}

		Hook.MemoizedState = MemoizedState
	end

	return MemoizedState.State, MemoizedState.Dispatch
end

return UseReducer
