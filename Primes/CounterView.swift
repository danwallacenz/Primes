//
//  CounterView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct CounterView: View {
    
    @ObservedObject var state: AppState
    
    @State private var isThisPrimeModalPresented: Bool = false
    @State var alertNthPrime: Int?
    @State var nthPrimeButtonDisabled = false
    
    var color: Color {
        state.count.isPrime ? .green : .red
    }
    
    var isPrimeModalView: some View {
        VStack {
            if state.count.isPrime {
                Text("\(self.state.count) is prime :)")

                if self.state.favouritePrimes.contains(self.state.count) {
                    Button(action: {
                        self.state.favouritePrimes.removeAll { $0 == self.state.count }
                    }) {
                        Text("Remove from favourite primes")
                    }
                } else {
                    Button(action: {
                          self.state.favouritePrimes.append(self.state.count)
                      }) {
                          Text("Add to favourite primes")
                      }
                }
            } else {
                Text("\(self.state.count) is not prime :(")
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Button(action: { self.state.count -= 1 }) {
                    Text("-")
                }
                Text("\(state.count)").foregroundColor(color)

                Button(action: { self.state.count += 1 }) {
                     Text("+")
                }
            }
            
            // Initiates modal
            Button(action: { self.isThisPrimeModalPresented = true},
                   label: { Text("Is this prime?") })
            
            Button(action: {
                self.nthPrimeButtonDisabled = true
                nthPrime(self.state.count) { prime in
                    self.nthPrimeButtonDisabled = false
                    self.alertNthPrime = prime // initiates Alert when non-nil
                }
            }, label: {
                Text("What is the \(ordinal(state.count)) prime?")
                }).disabled(nthPrimeButtonDisabled)
            
        }.font(.title)
        .navigationBarTitle("Counter demo")
        .sheet(isPresented: $isThisPrimeModalPresented)
        { IsPrimeModalView(state: self.state) }
        .alert(item: $alertNthPrime) { n in
            Alert(
                title: Text("The \(ordinal(self.state.count)) prime is \(n)"),
                dismissButton: Alert.Button.default( Text("OK"))
            )
        }
    }
}

