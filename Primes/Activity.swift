//
//  Activity.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import Foundation

struct Activity {
    let timestamp: Date
    let type: ActivityType

    enum ActivityType {
        case addedFavoritePrime(Int)
        case removedFavoritePrime(Int)
    }
}

extension Activity: Codable {
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case type
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        type = try values.decode(ActivityType.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(type, forKey: .type)
    }
}

extension Activity: Identifiable {
    var id: Int {
        Int(timestamp.timeIntervalSince1970)
    }
}

extension Activity: CustomStringConvertible {
    
    static var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .short
        return f
    }()
    
    var description: String {
        switch type {
        case .addedFavoritePrime(let count):
            return "Added [ \(count) ] \(Activity.formatter.string(from: timestamp))"
        case .removedFavoritePrime(let count):
            return "Removed [ \(count) ] \(Activity.formatter.string(from: timestamp))"
        }
    }
}

extension Activity.ActivityType: Codable {

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
    


