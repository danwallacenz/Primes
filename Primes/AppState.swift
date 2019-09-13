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

/// Combine two reducers into one
//func _combine<Value, Action>(
//    _ first: @escaping (inout Value, Action) -> Void,
//    _ second: @escaping (inout Value, Action) -> Void
//    ) -> (inout Value, Action) -> Void {
//        return { value, action in
//            first(&value, action)
//            second(&value, action)
//        }
//}

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

//func pullback<LocalValue, GlobalValue, Action>(
//    _ reducer: @escaping (inout LocalValue, Action) -> Void,
//    get: @escaping (GlobalValue) -> LocalValue,
//    set: @escaping (inout GlobalValue, LocalValue) -> Void
//) -> (inout GlobalValue, Action) -> Void {
//
//    return { globalValue, action in
//        var localValue = get(globalValue)
//        reducer(&localValue, action)
//        set(&globalValue, localValue)
//    }
//}

func pullback<LocalValue, GlobalValue, Action>(
    _ reducer: @escaping (inout LocalValue, Action) -> Void,
    value: WritableKeyPath<GlobalValue, LocalValue>
) -> (inout GlobalValue, Action) -> Void {
    
    return { globalValue, action in
        reducer(&globalValue[keyPath: value], action)
    }
}

// pass only the part of the AppState we care about (count)
func counterReducer(state: inout Int, action: AppAction) -> Void {
    
    switch action {
    case .counter(.decrTapped):
        state -= 1
    
    case .counter(.incrTapped):
        state += 1
    
    default:
        break
    }
}

func isPrimeModalReducer(state: inout AppState, action: AppAction) -> Void {
    
    switch action {
    case .isPrimeModal(.addFavouritePrimeTapped):
        state.favouritePrimes.append(state.count)
        state.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(state.count)))

    case .isPrimeModal(.removeFavouritePrimeTapped):
        let count = state.count // must do this when using inout
        state.favouritePrimes.removeAll(where: { $0 == count })
        state.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(state.count)))
        
    default:
        break
    }
}

struct FavouritePrimesState {
    var favouritePrimes: [Int]
    var activityFeed: [Activity]
}


// pass only the parts of the AppState we care about (favouritePrimes and activityFeed)
func favouritePrimesReducer(state: inout FavouritePrimesState, action: AppAction) -> Void {
    
    switch action {
    case .favouritePrimes(.deleteFavouritePrime(let indexSet)):
        for index in indexSet {
            let prime = state.favouritePrimes[index]
            state.favouritePrimes.removeAll(where: { $0 == prime })
            state.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(prime)))
        }
   
    default:
        break
    }
}

extension AppState {
    var favouritePrimesState: FavouritePrimesState {
        get {
            FavouritePrimesState(
                favouritePrimes: self.favouritePrimes,
                activityFeed: self.activityFeed
            )
        }
        set {
            self.favouritePrimes = newValue.favouritePrimes
            self.activityFeed = newValue.activityFeed
        }
    }
}

//let appReducer = combine(combine(counterReducer, isPrimeModalReducer), favouritePrimesReducer)
let appReducer = combine(
//    pullback(counterReducer, get: { $0.count }, set: { $0.count = $1 }), //<#(GlobalValue) -> LocalValue#>) { $0.count },
    pullback(counterReducer, value: \.count),
    isPrimeModalReducer,
    pullback(favouritePrimesReducer, value: \.favouritePrimesState)
)

//let appReducer = pullback(_appReducer, value: \.self)


//func appReducer(state: inout AppState,
//                    action: AppAction) {
//    switch action {
//
//    case .counter(.decrTapped):
//        state.count -= 1
//
//    case .counter(.incrTapped):
//        state.count += 1
//
//    case .isPrimeModal(.addFavouritePrimeTapped):
//        state.favouritePrimes.append(state.count)
//        state.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(state.count)))
//
//    case .isPrimeModal(.removeFavouritePrimeTapped):
//        let count = state.count // must do this when using inout
//        state.favouritePrimes.removeAll(where: { $0 == count })
//        state.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(state.count)))
//
//    case .favouritePrimes(.deleteFavouritePrime(let indexSet)):
//        for index in indexSet {
//            let prime = state.favouritePrimes[index]
//            state.favouritePrimes.removeAll(where: { $0 == prime })
//            state.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(prime)))
//        }
//    }
//}

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
