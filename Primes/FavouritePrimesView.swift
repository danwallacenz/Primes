//
//  FavouritePrimesView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct FavoritePrimesView: View {

    @ObservedObject var state: AppState
    
    var body: some View {
        List { ForEach(self.state.favouritePrimes) { favourite in
            Text("\(favourite)")
        }.onDelete(perform: { indexSet in
            self.state.removeFavouritePrimes(at: indexSet)
        })
        }.navigationBarTitle("Favourite primes")
    }
}
