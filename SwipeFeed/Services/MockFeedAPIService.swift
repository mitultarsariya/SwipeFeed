//
//  MockFeedService.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Foundation
import Combine

final class MockFeedAPIService: FeedServiceProtocol {
    
    enum MockErrorType {
        case unknown
        case decoding
        case invalidURL
    }
    
    var shouldReturnError = false
    var errorType: MockErrorType = .unknown
    var mockItems: [FeedItem] = [
        FeedItem(id: 1, title: "Mock Title 1", subtitle: "Mock Sub 1", content: "Mock Content 1"),
        FeedItem(id: 2, title: "Mock Title 2", subtitle: "Mock Sub 2", content: "Mock Content 2")
    ]
    
    func fetchFeed() -> AnyPublisher<[FeedItem], NetworkError> {
        if shouldReturnError {
            let error: NetworkError
            
            switch errorType {
            case .unknown:
                error = .unknown
            case .decoding:
                let decodingError = NSError(domain: "com.mock.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode"])
                error = .decoding(decodingError)
            case .invalidURL:
                error = .invalidURL
            }
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just(mockItems)
                .setFailureType(to: NetworkError.self)
                .delay(for: .milliseconds(100), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

