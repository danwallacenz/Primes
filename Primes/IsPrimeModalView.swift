//
//  IsPrimeModalView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct IsPrimeModalView: View {
    
    @ObservedObject var state: AppState
    
    var body: some View {
        VStack {
            if state.count.isPrime {
                Text("\(self.state.count) is prime :)")

                if self.state.favouritePrimes.contains(self.state.count) {
                    Button(action: {
                        self.state.favouritePrimes.removeAll { $0 == self.state.count }
                    }) {
                        Text("Remove from favourite primes")
                    }
                } else {
                    Button(action: {
                          self.state.favouritePrimes.append(self.state.count)
                      }) {
                          Text("Add to favourite primes")
                      }
                }
            } else {
                Text("\(self.state.count) is not prime :(")
            }
        }
    }
}
