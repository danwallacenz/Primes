//
//  Reducers.swift
//  Primes
//
//  Created by Daniel Wallace on 14/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

// MARK: - Reducers

/// Pass only the part of the AppState we care about (count) and the specific action - CounterAction
func counterReducer(state: inout Int, action: CounterAction) -> Void {
    
    switch action {
    case .decrTapped:
        state -= 1
    
    case .incrTapped:
        state += 1
    }
}

///  Pass only the specific action - IsPrimeModalAction. Uses most of the AppState so we'll just pass that all in
func isPrimeModalReducer(state: inout AppState, action: IsPrimeModalAction) -> Void {
    
    switch action {
    case .addFavouritePrimeTapped:
        state.favouritePrimes.append(state.count)

    case .removeFavouritePrimeTapped:
        let count = state.count // must do this when using inout
        state.favouritePrimes.removeAll(where: { $0 == count })
    }
}

// pass only the parts of the AppState we care about (favouritePrimes and activityFeed)
func favouritePrimesReducer(state: inout [Int], action: FavouritePrimesAction) -> Void {
    
    switch action {
    case .deleteFavouritePrime(let indexSet):
        for index in indexSet {
            let prime = state[index]
            state.removeAll(where: { $0 == prime })
        }
    }
}

// MARK: - App Reducer

let _appReducer: (inout AppState, AppAction) -> Void = combine(
    pullback(counterReducer, value: \.count, action: \.counter),
    pullback(isPrimeModalReducer, value: \.self, action: \.isPrimeModal),
    pullback(favouritePrimesReducer, value: \.favouritePrimes, action: \.favouritePrimes)
)
let appReducer = pullback(_appReducer, value: \.self, action: \.self)
