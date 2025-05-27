//
//  FeedListView.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import SwiftUI

struct FeedListView: View {
    @ObservedObject var feedVM: FeedViewModel

    var body: some View {
        NavigationView {
            List(feedVM.arrFeed) { item in
                ScrollView {
                    NavigationLink(destination: FeedDetailView(item: item)) {
                        FeedRowView(item: item)
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.lightBlueColor)
            .refreshable {
                feedVM.loadFeed()
            }
        }
    }
}

#Preview {
    FeedListView(feedVM: FeedViewModel.mock)
}
