//
//  ContentView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(store: self.store)) {
                    Text("Counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(store: self.store)) {
                    Text("Favourite primes")
                }
                NavigationLink(destination: ActivityFeedView(store: self.store)) {
                    Text("Activity feed")
                }
            }.navigationBarTitle("State management")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialValue: AppState.loadOrCreateAppState(),
                                 reducer: appReducer(state:action:)))
    }
}
