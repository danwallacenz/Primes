//
//  CounterView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct CounterView: View {
    
    @ObservedObject var store: Store<AppState, AppAction>
    
    @State private var isThisPrimeModalPresented: Bool = false
    @State var alertNthPrime: Int?
    @State var nthPrimeButtonDisabled = false
    
    var color: Color {
        self.store.value.count.isPrime ? .green : .red
    }
    
    public var body: some View {
        VStack {
            HStack {
                
                Button(action: {
                    
                    self.store.send(.counter(.decrTapped))
                    
                }) {
                    Text("-")
                }.padding()
                
                Text("\(self.store.value.count)")
                    .padding()
                    .foregroundColor(color)

                Button(action: {
                    
                    self.store.send(.counter(.incrTapped))
                    
                }) {
                     Text("+")
                }.padding()
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
        .alert(item: $alertNthPrime) { nthPrime in
            Alert(
                title: Text("The \(ordinal(self.store.value.count)) prime is \(nthPrime)"),
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

