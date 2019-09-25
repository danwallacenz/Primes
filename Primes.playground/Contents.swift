import UIKit
import SwiftUI
import ComposableArchitecture
import PrimeFramework
import PlaygroundSupport

PlaygroundPage.current.liveView = UIHostingController(
  rootView: ContentView(store: Store(
      initialValue: AppState.loadOrCreateAppState(),
      reducer: log(activityFeed(appReducer))
    )
  )
)

let store = Store<Int, Void>(initialValue: 0, reducer: { count, _ in count += 1 })

store.send(())
store.send(())
store.send(())
store.send(())
store.send(())
store.value

let newStore = store.view { $0 }
newStore.value

newStore.send(())
newStore.send(())
newStore.send(())
newStore.value

store.value

store.send(())
store.send(())
store.send(())
store.value
newStore.value
