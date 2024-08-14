--!optimize 2
--!strict

local HookUtility = require(script.Parent.HookUtility)

local function UseReducer<S, I, A>(reducer: (S, A) -> S, initialArgument: I, initialize: nil | (I) -> S): (S, (A) -> ())
	local component = HookUtility.ResolveCurrentlyRenderingComponent()
	local hook = HookUtility.CreateWorkInProgressHook()
	local memoizedState = hook.MemoizedState

	if not HookUtility.IsReRender then
		local initialState
		if reducer == HookUtility.BasicStateReducer then
			if type(initialArgument) == "function" then
				initialState = initialArgument()
			else
				initialState = initialArgument
			end
		else
			if initialize then
				initialState = initialize(initialArgument)
			else
				initialState = initialArgument
			end
		end

		local function dispatch(action)
			local previousState = memoizedState.State
			local nextState = reducer(previousState, action)
			if nextState == previousState then
				return
			end

			memoizedState.State = nextState
			component:setState({
				[hook.Index] = nextState;
			})

			return nextState
		end

		memoizedState = {
			Dispatch = dispatch;
			State = initialState;
		}

		hook.MemoizedState = memoizedState
	end

	return memoizedState.State, memoizedState.Dispatch
end

return UseReducer
