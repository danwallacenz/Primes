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
                    Button(action: removeFavouritePrimeAction) {
                        Text("Remove from favourite primes")
                    }
                } else {
                    Button(action: addFavouritePrimeAction) {
                          Text("Add to favourite primes")
                      }
                }
            } else {
                Text("\(self.state.count) is not prime :(")
            }
        }
    }
    
    func removeFavouritePrimeAction() {
        self.state.removeFavouritePrime()
    }
    
    func addFavouritePrimeAction() {
        self.state.addFavouritePrime()
    }
}
