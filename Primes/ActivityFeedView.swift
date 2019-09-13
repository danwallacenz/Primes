//
//  ActivityFeedView.swift
//  Primes
//
//  Created by Daniel Wallace on 13/09/19.
//  Copyright © 2019 danwallacenz. All rights reserved.
//

import SwiftUI

struct ActivityFeedView: View {

    @ObservedObject var state: AppState
    
    var body: some View {
        List { ForEach(self.state.activityFeed) { activity in
            Text("\(activity.description) ")
            }
        }.navigationBarTitle("Activity feed")
    }

}
