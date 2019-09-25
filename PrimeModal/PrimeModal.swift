
public enum PrimeModalAction {
    case addFavouritePrimeTapped
    case removeFavouritePrimeTapped
}

public typealias PrimeModalState = (count: Int, favouritePrimes: [Int])

//public struct PrimeModalState {
//    public var count: Int
//    public var favouritePrimes: [Int]
//
//    public init(count: Int, favouritePrimes: [Int]) {
//        self.count = count
//        self.favouritePrimes = favouritePrimes
//    }
//}

///  Pass only the specific action - IsPrimeModalAction. Uses most of the AppState so we'll just pass that all in
public func primeModalReducer(state: inout PrimeModalState, action: PrimeModalAction) -> Void {
    
    switch action {
    case .addFavouritePrimeTapped:
        state.favouritePrimes.append(state.count)

    case .removeFavouritePrimeTapped:
        //let count = state.count // must do this when using inout
        state.favouritePrimes.removeAll(where: { $0 == state.count })
    }
}
