//
//  AppState.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Foundation
import Combine

class AppState: ObservableObject, Codable {
    
    @Published var count = 0 {
        didSet { saveState() }
    }
    
    @Published var favouritePrimes: [Int] = [] {
        didSet { saveState() }
    }
    
    @Published var activityFeed: [Activity] = [] {
        didSet {
            saveState()
        }
    }
    
    // MARK: -
    
    init() {}
    
    // MARK: -
    
    static func loadOrCreateAppState() -> AppState {
        if let jsonData = UserDefaults.standard.data(forKey: "APP_STATE"),
            let appState = try? JSONDecoder().decode(AppState.self, from: jsonData) {
            print(appState)
            return appState
        } else {
            return AppState()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case count
        case favouritePrimes
        case activityFeed
    }
    
    required init(from decoder: Decoder) throws {
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
