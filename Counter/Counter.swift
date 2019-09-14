
public enum CounterAction {
    case decrTapped
    case incrTapped
}

/// Pass only the part of the AppState we care about (count) and the specific action - CounterAction
public func counterReducer(state: inout Int, action: CounterAction) -> Void {
    
    switch action {
    case .decrTapped:
        state -= 1
    
    case .incrTapped:
        state += 1
    }
}
