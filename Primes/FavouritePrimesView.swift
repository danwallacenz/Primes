//
//  FavouritePrimesView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct FavoritePrimesView: View {

    @ObservedObject var store: Store<AppState>
    
    var body: some View {
        List { ForEach(self.store.value.favouritePrimes) { favourite in
            Text("\(favourite)")
        }.onDelete(perform: { indexSet in
            //self.store.value.removeFavouritePrimes(at: indexSet)
            for index in indexSet {
                let prime = self.store.value.favouritePrimes[index]
                self.store.value.favouritePrimes.removeAll(where: { $0 == prime })
                self.store.value.activityFeed.append(Activity(timestamp: Date(), type: .removedFavoritePrime(prime)))
            }
        })
        }.navigationBarTitle("Favourite primes")
    }
}
