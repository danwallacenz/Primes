//
//  IsPrimeModalView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct IsPrimeModalView: View {
    
    @ObservedObject var store: Store<AppState, CounterAction>
    
    var body: some View {
        VStack {
            if self.store.value.count.isPrime {
                Text("\(self.store.value.count) is prime :)")

                if self.store.value.favouritePrimes.contains(self.store.value.count) {
                    Button(action: removeFavouritePrimeAction) {
                        Text("Remove from favourite primes")
                    }
                } else {
                    Button(action: addFavouritePrimeAction) {
                          Text("Add to favourite primes")
                      }
                }
            } else {
                Text("\(self.store.value.count) is not prime :(")
            }
        }
    }
    
    func removeFavouritePrimeAction() {
        self.store.value.favouritePrimes.removeAll(where: { $0 == self.store.value.count })
        self.store.value.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(self.store.value.count)))
//        self.store.value.removeFavouritePrime()
    }
    
    func addFavouritePrimeAction() {
        self.store.value.favouritePrimes.append(self.store.value.count)
        self.store.value.activityFeed.append(Activity(timestamp: Date(), type: .addedFavoritePrime(self.store.value.count)))
//        self.store.value.addFavouritePrime()
    }
}
