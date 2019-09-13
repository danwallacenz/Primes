//
//  ActivityFeedView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct ActivityFeedView: View {
    
    @ObservedObject var store: Store<AppState>
    
    var body: some View {
        List { ForEach(self.store.value.activityFeed.reversed()) { activity in
            Text("\(activity.description) ")
        }.multilineTextAlignment(.leading)
            .lineLimit(nil)
            .padding()
        }.navigationBarTitle("Activity feed")
    }

}
