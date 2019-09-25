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
