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
public let appReducer = pullback(_appReducer, value: \.self, action: \.self)

// MARK: - Aspect activityFeed

public func activityFeed(
    _ reducer: @escaping (inout AppState, AppAction) -> Void)
    -> (inout AppState, AppAction) -> Void {
        
    return { state, action in
        switch action {
        case .counter:
            break
        
        case let .favouritePrimes(.deleteFavouritePrime(indexSet)):
            for index in indexSet {
                let prime = state.favouritePrimes.reversed()[index] // note reversed
                state.activityFeed.append(AppState.Activity(timestamp: Date(), type: .removedFavoritePrime(prime)))
            }
       
        case .primeModal(.addFavouritePrimeTapped):
            state.activityFeed.append(AppState.Activity(timestamp: Date(), type: .addedFavoritePrime(state.count)))
       
        case .primeModal(.removeFavouritePrimeTapped):
            state.activityFeed.append(AppState.Activity(timestamp: Date(), type: .removedFavoritePrime(state.count)))
        }
        return reducer(&state, action)
    }
}
