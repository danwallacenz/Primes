//
//  AppState.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Foundation
import Combine

final class Store<Value, Action>: ObservableObject {
    
    let reducer: (inout Value, Action) -> Void
    
    @Published var value: Value

    init(initialValue: Value,
         reducer: @escaping (inout Value, Action) -> Void) {
        self.value = initialValue
        self.reducer = reducer
    }
    
    func send(_ action: Action) {
        reducer(&value, action)
    }
}

enum CounterAction {
    case decrTapped
    case incrTapped
}

enum IsPrimeModalAction {
    case addFavouritePrimeTapped
    case removeFavouritePrimeTapped
}

enum FavouritePrimesAction {
    case deleteFavouritePrime(IndexSet)
}

enum AppAction {
    case counter(CounterAction)
    case isPrimeModal(IsPrimeModalAction)
    case favouritePrimes(FavouritePrimesAction)
}

func appReducer(state: inout AppState,
                    action: AppAction) {
    switch action {
        
    case .counter(.decrTapped):
        state.count -= 1
    
    case .counter(.incrTapped):
        state.count += 1
    
    case .isPrimeModal(.addFavouritePrimeTapped):
        state.favouritePrimes.append(state.count)
        state.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(state.count)))

    case .isPrimeModal(.removeFavouritePrimeTapped):
        let count = state.count // must do this when using inout
        state.favouritePrimes.removeAll(where: { $0 == count })
        state.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(state.count)))
    
    case .favouritePrimes(.deleteFavouritePrime(let indexSet)):
        for index in indexSet {
            let prime = state.favouritePrimes[index]
            state.favouritePrimes.removeAll(where: { $0 == prime })
            state.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(prime)))
        }
    }
}

struct AppState {
    
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

    init() {}

    static func loadOrCreateAppState() -> AppState {
        if let jsonData = UserDefaults.standard.data(forKey: "APP_STATE"),
            let appState = try? JSONDecoder().decode(AppState.self, from: jsonData) {
            print(appState)
            return appState
        } else {
            return AppState()
        }
    }
}

extension AppState: Codable {
    
    enum CodingKeys: String, CodingKey {
        case count
        case favouritePrimes
        case activityFeed
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decode(Int.self, forKey: .count)
        favouritePrimes = try values.decode([Int].self, forKey: .favouritePrimes)
        activityFeed = try values.decode([Activity].self, forKey: .activityFeed)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(favouritePrimes, forKey: .favouritePrimes)
        try container.encode(activityFeed, forKey: .activityFeed)
    }
    
    private func saveState() {
        if let json = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(json, forKey: "APP_STATE")
        } else {
            print("could not encode \(self)")
        }
    }
}

extension AppState: CustomStringConvertible {
    var description: String {
        "count: \(count)\nfavourite primes:\(favouritePrimes)\nactivity: \(activityFeed)"
    }
}
