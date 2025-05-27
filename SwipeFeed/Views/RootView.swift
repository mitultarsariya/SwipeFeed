//
//  RootView.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var feedVM = FeedViewModel()
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                PullToRefreshView(isLoading: $isLoading, onRefresh: {
                    feedVM.loadFeed()
                }) {
                    VStack {
                        Spacer()
                        Image("img_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 132, height: 60)
                        Spacer()
                    }
                }
            } else {
                FeedListView(feedVM: feedVM)
            }
        }
        .onReceive(feedVM.$arrFeed) { feed in
            if !feed.isEmpty {
                isLoading = false
            }
        }
    }
}


#Preview {
    RootView()
}
