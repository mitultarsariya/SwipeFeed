//
//  FeedServiceProtocol.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Combine

protocol FeedServiceProtocol {
    func fetchFeed() -> AnyPublisher<[FeedItem], NetworkError>
}
