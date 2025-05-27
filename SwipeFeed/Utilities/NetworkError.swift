//
//  NetworkError.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case decoding(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return AppStrings.Errors.invalidURL
        case .decoding(let error):
            return AppStrings.Errors.decoding(error)
        case .unknown:
            return AppStrings.Errors.unknown
        }
    }
}
