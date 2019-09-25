//
//  ContentView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct ContentView: View {
    
    @ObservedObject var store: Store<AppState, AppAction>
    
    public var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(store: self.store.view { ($0.count, $0.favouritePrimes) })) {
                    Text("Counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(
                    store: self.store.view { $0.favouritePrimes }
                    )
                ) {
                    Text("Favourite primes")
                }
                NavigationLink(destination: ActivityFeedView(store: self.store)) {
                    Text("Activity feed")
                }
            }.navigationBarTitle("State management")
        }
    }
    
    public init(store: Store<AppState, AppAction>) {
        self.store = store
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialValue: AppState.loadOrCreateAppState(),
                reducer: activityFeed(appReducer)
            )
        )
    }
}
