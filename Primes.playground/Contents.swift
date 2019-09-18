//: A UIKit based Playground for presenting user interface
  
import UIKit
import SwiftUI
import PlaygroundSupport
import PrimeFramework
import ComposableArchitecture

PlaygroundPage.current.liveView = UIHostingController(
  rootView: ContentView(store: Store(
      initialValue: AppState.loadOrCreateAppState(),
      reducer: log(activityFeed(appReducer))
    )
  )
)
