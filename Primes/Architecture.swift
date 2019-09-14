//
//  Store.swift
//  Primes
//
//  Created by Daniel Wallace on 14/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Combine

final class Store<Value, Action>: ObservableObject {
    
    let reducer: (inout Value, Action) -> Void
    
    // can only mutate via send(_:)
    @Published private(set) var value: Value

    init(initialValue: Value,
         reducer: @escaping (inout Value, Action) -> Void) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer(&value, action)
    }
}

func pullback<LocalValue, GlobalValue, GlobalAction, LocalAction>(
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
func combine<Value, Action>(
    _ reducers: (inout Value, Action) -> Void...
    ) -> (inout Value, Action) -> Void {
    
    return { value, action in
        for reducer in reducers {
            reducer(&value, action)
        }
    }
}
