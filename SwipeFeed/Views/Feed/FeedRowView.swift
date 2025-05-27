//
//  FeedRowView.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import SwiftUI

struct FeedRowView: View {
    let item: FeedItem

    var body: some View {
        HStack(spacing: 15) {
            Text(item.title)
                .font(.headline)
                .foregroundStyle(Color.navyBlueColor)
            
            Spacer()
            
            Text(item.subtitle)
                .font(.subheadline)
                .foregroundStyle(Color.grayColor)
            
            Image("ic_right_arrow")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 13)
        }
        .frame(height: 75)
    }
}

#Preview {
    FeedRowView(item: FeedItem(id: 1, title: "First Item", subtitle: "This is the subtitle", content: "This is the full content"))
}
