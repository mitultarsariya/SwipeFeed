//
//  APIConstants.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Foundation

enum APIConstants {
    static let baseURL = "https://raw.githubusercontent.com"
    static let feedPath = "/catchnz/ios-test/master/data/data.json"

    static var feedURL: URL? {
        return URL(string: baseURL + feedPath)
    }
}


