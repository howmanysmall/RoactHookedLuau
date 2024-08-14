--!optimize 2
--!strict

type RoactElement = {[any]: any}
type RoactNode = nil | boolean | number | string | RoactElement | {RoactNode?} | {[string]: RoactNode?, UNIQUE_TAG: any?}

type AbstractComponent<Config, Instance> = {
	defaultProps: Config?,
	render: nil | (props: Config) -> RoactNode,
	[string]: any,
}

type ComponentType<Config> = AbstractComponent<Config, any>

-- type Binding<T> = {
-- 	current: T,
-- 	getValue: (self: Binding<T>) -> T,
-- 	map: (self: Binding<T>, predicate: (value: T) -> T) -> T,
-- }

-- export type RoactBinding<T> = {
-- 	current: T,
-- 	getValue: (self: RoactBinding<T>) -> T,
-- 	map: <U>(self: RoactBinding<T>, predicate: (value: T) -> U) -> Binding<U>,
-- }

export type CoreRoactBinding<T> = {
	getValue: (self: CoreRoactBinding<T>) -> T,
}
export type RoactBindingMap = {
	map: <T, U>(self: CoreRoactBinding<T> & RoactBindingMap, (T) -> U) -> RoactBindingMap & CoreRoactBinding<U>,
}

export type RoactBinding<T> = CoreRoactBinding<T> & RoactBindingMap
export type RoactBindingUpdater<T> = (T) -> ()

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

export type UseBinding = <T>(initialValue: T) -> (CoreRoactBinding<T> & RoactBindingMap, (newValue: T) -> ())
export type UseCallback = <T>(callback: T, dependencies: {unknown}?) -> T
export type UseContext = <T>(context: RoactContext<T>) -> T
export type UseEffect = (create: (() -> () -> ()) | (() -> ()), dependencies: {unknown}?) -> ()
export type UseMemo = <T...>(callback: () -> T..., dependencies: {unknown}?) -> T...
export type UseMutable = <T>(initialValue: T) -> {current: T}
export type UseReducer = <State, Initial, Action>(
	reducer: (state: State, action: Action) -> State,
	initialArgument: Initial,
	initialize: nil | (initialArgument: Initial) -> State
) -> (State, (action: Action) -> ())
export type UseRef = <T>() -> RoactRef<T>
export type UseState = <S>(initialState: S | (() -> S)) -> (S, (newState: ((currentState: S) -> S) | S) -> ())

return false
