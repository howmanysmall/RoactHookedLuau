--!optimize 2
type RoactElement = {[any]: any}
type RoactNode = nil | boolean | number | string | RoactElement | {RoactNode?} | {[string]: RoactNode?, UNIQUE_TAG: any?}

type AbstractComponent<Config, Instance> = {
	render: nil | (props: Config) -> RoactNode,
	defaultProps: Config?,
	[string]: any,
}

type ComponentType<Config> = AbstractComponent<Config, any>

type Binding<T> = {
	current: T,
	getValue: (self: Binding<T>) -> T,
	map: (self: Binding<T>, predicate: (value: T) -> T) -> T,
}

export type RoactBinding<T> = {
	current: T,
	getValue: (self: RoactBinding<T>) -> T,
	map: <U>(self: RoactBinding<T>, predicate: (value: T) -> U) -> Binding<U>,
}

type RoactChildren = typeof(newproxy(false))

export type RoactContext<T> = {
	Consumer: ComponentType<{[RoactChildren]: (value: T) -> RoactNode?}>,
	Provider: ComponentType<{value: T, [RoactChildren]: RoactNode?}>,
}

type ElementRef<C> = C

export type RoactRef<ElementType> = {
	current: ElementRef<ElementType>?,
	getValue: (self: RoactRef<ElementType>) -> ElementRef<ElementType>?,
} | ((ElementRef<ElementType>?) -> ())

export type NoOp = () -> ()
export type FunctionWithNoOp = () -> NoOp

export type UseBinding = <T>(InitialValue: T) -> (RoactBinding<T>, (NewValue: T) -> ())
export type UseCallback = <T>(Function: T, Dependencies: {any}?) -> T
export type UseContext = <T>(Context: RoactContext<T>) -> T
export type UseEffect = (Function: FunctionWithNoOp | NoOp, Dependencies: {any}?) -> ()
export type UseMemo = <T>(Function: () -> T, Dependencies: {any}?) -> T
export type UseMutable = <T>(InitialValue: T) -> {current: T}
export type UseReducer = <State, Action>(
	Reducer: (State: State, Action: Action) -> State,
	InitialState: State
) -> (State, (Action: Action) -> ())

export type UseRef = <T>() -> RoactRef<T & Instance>
export type UseState = <T>(State: T) -> (T, (NewState: T) -> ())

return false
