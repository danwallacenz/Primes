//
//  CounterView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct CounterView: View {
    
    @ObservedObject var store: Store<AppState, AppAction>
    
    @State private var isThisPrimeModalPresented: Bool = false
    @State var alertNthPrime: Int?
    @State var nthPrimeButtonDisabled = false
    
    var color: Color {
        self.store.value.count.isPrime ? .green : .red
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Button(action: {
//                    self.store.value.count -= 1
//                    self.store.value = counterReducer(state: self.store.value, action: .decrTapped)
                    self.store.send(.counter(.decrTapped))
                }) {
                    Text("-")
                }
                Text("\(self.store.value.count)").foregroundColor(color)

                Button(action: {
//                    self.store.value.count += 1
//                    self.store.value = counterReducer(state: self.store.value, action: .incrTapped)
                    self.store.send(.counter(.incrTapped))
                }) {
                     Text("+")
                }
            }
            
            // Initiates modal
            Button(action: { self.isThisPrimeModalPresented = true },
                   label: { Text("Is this prime?") })
            
            Button(action: nthPrimeButtonAction, label: {
                Text("What is the \(ordinal(self.store.value.count)) prime?")
                }).disabled(nthPrimeButtonDisabled)
            
        }.font(.title)
        .navigationBarTitle("Counter demo")
        .sheet(isPresented: $isThisPrimeModalPresented)
        { IsPrimeModalView(store: self.store) }
        .alert(item: $alertNthPrime) { n in
            Alert(
                title: Text("The \(ordinal(self.store.value.count)) prime is \(n)"),
                dismissButton: Alert.Button.default( Text("OK"))
            )
        }
    }
    
    func nthPrimeButtonAction() {
        self.nthPrimeButtonDisabled = true
        nthPrime(self.store.value.count) { prime in
            self.nthPrimeButtonDisabled = false
            self.alertNthPrime = prime // initiates Alert when non-nil
        }
    }
}

