//
//  IsPrimeModalView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct IsPrimeModalView: View {
    
    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        VStack {
            if self.store.value.count.isPrime {
                
                Text("\(self.store.value.count) is prime :)")

                if self.store.value.favouritePrimes.contains(self.store.value.count) {
                    
                    Button("Remove from favourite primes") {
                        
                        self.store.send(.primeModal(.removeFavouritePrimeTapped))
                    }

                } else {
                    
                    Button("Add to favourite primes") {
                        
                        self.store.send(.primeModal(.addFavouritePrimeTapped))
                    }
                }
            } else {
                
                Text("\(self.store.value.count) is not prime :(")
            }
        }
    }
}
