//
//  FavouritePrimesView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct FavoritePrimesView: View {

    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        List { ForEach(self.store.value.favouritePrimes.reversed()) { favourite in
            
                Text("\(favourite)")
        
            }.onDelete(perform: { indexSet in
                
                self.store.send(.favouritePrimes(.deleteFavouritePrime(indexSet)))
                
            })
        }
        .navigationBarTitle("Favourite primes")
    }
}
