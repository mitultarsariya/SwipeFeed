//
//  AppStrings.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Foundation

enum AppStrings {
    enum Errors {
        static let invalidURL = "Invalid URL"
        static let unknown = "An unknown error occurred"
        static func decoding(_ error: Error) -> String {
            return "Decoding error: \(error.localizedDescription)"
        }
    }

    enum UI {
        static let loading = "Loading..."
        static let retry = "Retry"
        static let noData = "No data available"
    }
}
