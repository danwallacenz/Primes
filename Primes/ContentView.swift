//
//  ContentView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var state: AppState
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CounterView(state: state)) {
                    Text("Counter demo")
                }
                NavigationLink(destination: FavoritePrimesView(state: state)) {
                    Text("Favourite primes")
                }
            }.navigationBarTitle("State management")
        }
    }
}

class AppState: ObservableObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case count
        case favouritePrimes
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decode(Int.self, forKey: .count)
        favouritePrimes = try values.decode([Int].self, forKey: .favouritePrimes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(favouritePrimes, forKey: .favouritePrimes)
        
    }
    
    @Published var count = 0 {
        didSet {
            saveState()
        }
    }
    
    @Published var favouritePrimes: [Int] = [] {
        didSet {
            saveState()
        }
    }
    
    private func saveState() {
        if let json = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(json, forKey: "APP_STATE")
        }
    }
}

struct CounterView: View {
    
    @ObservedObject var state: AppState
    
    @State private var isThisPrimeModalPresented: Bool = false
    @State var alertNthPrime: Int?
    
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
            
            Button(action: { self.isThisPrimeModalPresented = true},
                   label: { Text("Is this prime?") })
            
//            Button(action: {
//                nthPrime(self.state.count) { prime in
//                  self.alertNthPrime = prime // initiates Alert when non-nil
//                }
//            }, label: {
//                Text("What is the \(ordinal(state.count)) prime?")
//            }).alert(item: $alertNthPrime) { n in
//                Alert(
//                    title: Text("The \(ordinal(self.state.count)) prime is \(n)"),
//                    dismissButton: Alert.Button.default( Text("OK"))
//                )
//            }
            
        }.font(.title)
        .navigationBarTitle("Counter demo")
        .sheet(isPresented: $isThisPrimeModalPresented)
        { self.isPrimeModalView }
    }
}

struct IsPrimeModalView: View {
    
    @ObservedObject var state: AppState
    
    var body: some View {
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
}

struct FavoritePrimesView: View {

    @ObservedObject var state: AppState
    
    var body: some View {
        List { ForEach(self.state.favouritePrimes) { favourite in
            Text("\(favourite)")
            }
        }.navigationBarTitle("Favourite primes")
    }
}

func loadOrCreateAppState() -> AppState {
    if let jsonData = UserDefaults.standard.data(forKey: "APP_STATE"),
        let appState = try? JSONDecoder().decode(AppState.self, from: jsonData) {
        return appState
    } else {
        return AppState()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(state: loadOrCreateAppState())
    }
}
