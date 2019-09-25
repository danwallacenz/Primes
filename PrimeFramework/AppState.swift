//
//  State.swift
//  Primes
//
//  Created by Daniel Wallace on 14/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Foundation
import PrimeModal

public struct AppState {
    
    var count = 0 {
        didSet { saveState() }
    }
    
    var favouritePrimes: [Int] = [] {
        didSet { saveState() }
    }
    
    var activityFeed: [Activity] = [] {
        didSet {
            saveState()
        }
    }
    
    struct Activity: Codable {
        let timestamp: Date
        let type: ActivityType

        enum ActivityType {
            case addedFavoritePrime(Int)
            case removedFavoritePrime(Int)
        }
    }
}

// MARK:- Computed property: provides a KeyPath

// for provide a keypath for appReducer - don't like this much
extension AppState {
    var primeModal: PrimeModalState {
        get {
            PrimeModalState(count: count, favouritePrimes: favouritePrimes)
        }
        set {
            self.count = newValue.count
            self.favouritePrimes = newValue.favouritePrimes
        }
    }
}

// MARK:- Save/load

extension AppState: Codable {
    
    public static func loadOrCreateAppState() -> AppState {
        if let jsonData = UserDefaults.standard.data(forKey: "APP_STATE"),
            let appState = try? JSONDecoder().decode(AppState.self, from: jsonData) {
            return appState
        } else {
            return AppState()
        }
    }
    
    private func saveState() {
        if let json = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(json, forKey: "APP_STATE")
        } else {
            fatalError("could not encode \(self)")
        }
    }
}

// MARK:- CustomStringConvertible

extension AppState: CustomStringConvertible {
    public var description: String {
        let activity = activityFeed.reversed().reduce("") {
            $0 + "\($1)\n"
        }
        return "count: \(count)\nfavourite primes:\(favouritePrimes)\nactivity:\n\(activity)"
    }
}
