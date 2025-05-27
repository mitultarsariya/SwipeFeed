//
//  FeedItem.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Foundation

struct FeedItem: Codable, Identifiable, Hashable {
    
    
    let id: Int
    let title: String
    let subtitle: String
    let content: String
}
