//
//  FeedService.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Foundation
import Combine

final class FeedAPIService: FeedServiceProtocol {
    
    func fetchFeed() -> AnyPublisher<[FeedItem], NetworkError> {
        guard let url = APIConstants.feedURL else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.unknown
                }
                return output.data
            }
            .decode(type: [FeedItem].self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.decoding(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
