//
//  FeedDetailView.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import SwiftUI

struct FeedDetailView: View {
    let item: FeedItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(item.content)
                    .font(.body)
                    .foregroundStyle(Color.navyBlueColor)
                    .padding()
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FeedDetailView(item: FeedItem(id: 1, title: "First Item", subtitle: "This is the subtitle", content: "This is the full content"))
}
