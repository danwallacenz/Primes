//
//  Activity.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Foundation

// MARK: - Identifiable

extension AppState.Activity: Identifiable {
    var id: Int {
        Int(timestamp.timeIntervalSince1970)
    }
}

// MARK: - CustomStringConvertible

extension AppState.Activity: CustomStringConvertible {
    
    static var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .short
        return f
    }()
    
    var description: String {
        switch type {
        case .addedFavoritePrime(let count):
            return "Added [ \(count) ] \(AppState.Activity.formatter.string(from: timestamp))"
        case .removedFavoritePrime(let count):
            return "Removed [ \(count) ] \(AppState.Activity.formatter.string(from: timestamp))"
        }
    }
}

// MARK: - Codable

extension AppState.Activity.ActivityType: Codable {

    enum CodingKeys: String, CodingKey {
        case addedFavoritePrime
        case removedFavoritePrime
    }
    
    enum CodingError: Error { case decoding(String) }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let addedFavoritePrime = try? values.decode(Int.self, forKey: .addedFavoritePrime) {
          self = .addedFavoritePrime(addedFavoritePrime)
          return
        }

        if let removedFavoritePrime = try? values.decode(Int.self, forKey: .removedFavoritePrime) {
          self = .removedFavoritePrime(removedFavoritePrime)
          return
        }
        throw CodingError.decoding("Decoding Failed. \(dump(values))")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .addedFavoritePrime(addedFavoritePrime):
          try container.encode(addedFavoritePrime, forKey: .addedFavoritePrime)
        case let .removedFavoritePrime(removedFavoritePrime):
          try container.encode(removedFavoritePrime, forKey: .removedFavoritePrime)
        }
    }
}

