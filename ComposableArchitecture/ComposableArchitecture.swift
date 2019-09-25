import Combine

public final class Store<Value, Action>: ObservableObject {
    
    private let reducer: (inout Value, Action) -> Void
    
    // can only mutate via send(_:)
    @Published public private(set) var value: Value
    
    private var cancellable: Cancellable?

    public init(initialValue: Value,
                reducer: @escaping (inout Value, Action) -> Void
    ) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    public func send(_ action: Action) {
        reducer(&value, action)
    }
    
    public func view<LocalValue>(
        _ f: @escaping (Value) -> LocalValue
    ) -> Store<LocalValue, Action> {
        
        let localStore = Store<LocalValue, Action>(
            initialValue: f(self.value),
            reducer: { localValue, action in
                self.send(action)
                localValue = f(self.value)
            }
        )
        localStore.cancellable = self.$value.sink { [weak localStore] newValue in
            localStore?.value = f(newValue)
        }
        return localStore
    }
}

/// Transform a reducer that understands local state and actions into one that understands global state and actions:
public func pullback<LocalValue, GlobalValue, GlobalAction, LocalAction>(
    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> (inout GlobalValue, GlobalAction) -> Void {
    
    return { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return }
        reducer(&globalValue[keyPath: value], localAction)
    }
}

/// Combine many reducers into one
/// Allows us to join multiple reducers together into a single mega reducer
public func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
    ) -> (inout Value, Action) -> Void {
    
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}

public func log<Value, Action>(
    _ reducer: @escaping (inout Value, Action) -> Void)
    -> (inout Value, Action) -> Void {
        
    return { value, action in
        reducer(&value, action)
        print("Action: \(action)")
        print(value)
        print("---")
    }
}
