//
//  Actions.swift
//  Primes
//
//  Created by Daniel Wallace on 14/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Foundation
import FavoritePrimes
import Counter
import PrimeModal

enum AppAction {
    case counter(CounterAction)
    case primeModal(PrimeModalAction)
    case favouritePrimes(FavouritePrimesAction)

    // generated by generate-enum-properties
    // allows keypath acces to enum properties
    var counter: CounterAction? {
        get {
            guard case let .counter(value) = self else { return nil }
            return value
        }
        set {
            guard case .counter = self, let newValue = newValue else { return }
            self = .counter(newValue)
        }
    }

    // generated by generate-enum-properties
    // allows keypath acces to enum properties
    var primeModal: PrimeModalAction? {
        get {
            guard case let .primeModal(value) = self else { return nil }
            return value
        }
        set {
            guard case .primeModal = self, let newValue = newValue else { return }
            self = .primeModal(newValue)
        }
    }

    // generated by generate-enum-properties
    // allows keypath acces to enum properties
    var favouritePrimes: FavouritePrimesAction? {
        get {
            guard case let .favouritePrimes(value) = self else { return nil }
            return value
        }
        set {
            guard case .favouritePrimes = self, let newValue = newValue else { return }
            self = .favouritePrimes(newValue)
        }
    }
}

