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

enum FavouritePrimesAction {
    case addFavouritePrimeTapped
    case removeFavouritePrimeTapped
}

enum AppAction {
    case counter(CounterAction)
    case favouritePrime(FavouritePrimesAction)
    
//    case decrTapped
//    case incrTapped
//    case addFavouritePrimeTapped
//    case removeFavouritePrimeTapped
}

func appReducer(state: inout AppState,
                    action: AppAction) {
    switch action {
    case .counter(.decrTapped):
        state.count -= 1
    case .counter(.incrTapped):
        state.count += 1
    case .favouritePrime(.addFavouritePrimeTapped):
        state.favouritePrimes.append(state.count)
        state.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(state.count)))

    case .favouritePrime(.removeFavouritePrimeTapped):
        let count = state.count // must do this for inout
        state.favouritePrimes.removeAll(where: { $0 == count })
        state.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(state.count)))

    }
}

//    func removeFavouritePrimeAction() {
//        self.store.value.favouritePrimes.removeAll(where: { $0 == self.store.value.count })
//        self.store.value.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(self.store.value.count)))
////        self.store.value.removeFavouritePrime()
//    }
//
//    func addFavouritePrimeAction() {
//        self.store.value.favouritePrimes.append(self.store.value.count)
//        self.store.value.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(self.store.value.count)))
///       self.store.value.addFavouritePrime()
//    }


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

//extension AppState {
//  func addFavouritePrime() {
//    self.favouritePrimes.append(self.count)
//    self.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(self.count)))
//  }
//
//  func removeFavouritePrime(_ prime: Int) {
//    self.favouritePrimes.removeAll(where: { $0 == prime })
//    self.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(prime)))
//  }
//
//  func removeFavouritePrime() {
//    self.removeFavouritePrime(self.count)
//  }
//
//  func removeFavouritePrimes(at indexSet: IndexSet) {
//    for index in indexSet {
//      self.removeFavouritePrime(self.favouritePrimes[index])
//    }
//  }
//}
