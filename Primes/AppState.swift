//
//  State.swift
//  Primes
//
//  Created by Daniel Wallace on 14/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Foundation
import PrimeModal

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
}

// for provide a keypath for appReducer - don't like this much
extension AppState {
    var primeModal: PrimeModalState {
        get {
            PrimeModalState.init(count: count, favouritePrimes: favouritePrimes)
        }
        set {
            self.count = newValue.count
            self.favouritePrimes = newValue.favouritePrimes
        }
    }
}

// MARK:- AppState Codable

extension AppState: Codable {
    
    static func loadOrCreateAppState() -> AppState {
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
}

// MARK:-

extension AppState: CustomStringConvertible {
    var description: String {
        let activity = activityFeed.reversed().reduce("") {
            $0 + "\($1)\n"
        }
        return "count: \(count)\nfavourite primes:\(favouritePrimes)\nactivity:\n\(activity)"
    }
}
