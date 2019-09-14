

func log<Value, Action>(
    _ reducer: @escaping (inout Value, Action) -> Void)
    -> (inout Value, Action) -> Void {
        
    return { value, action in
        reducer(&value, action)
        print("Action: \(action)")
        print(value)
        print("---")
    }
}
