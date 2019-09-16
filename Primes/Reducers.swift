//
//  Reducers.swift
//  Primes
//
//  Created by Daniel Wallace on 14/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import ComposableArchitecture
import FavoritePrimes
import Counter
import PrimeModal

// MARK: - App Reducer

let _appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(counterReducer,            value:  \.count,            action: \.counter),
    pullback(primeModalReducer,         value:  \.primeModal,       action: \.primeModal),
    pullback(favouritePrimesReducer,    value:  \.favouritePrimes,  action: \.favouritePrimes)
)
let appReducer = pullback(_appReducer, value: \.self, action: \.self)
