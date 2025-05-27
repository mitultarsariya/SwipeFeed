//
//  FeedViewModelTests.swift
//  SwipeFeedTests
//
//  Created by iMac on 27/05/25.
//

import XCTest
import Combine
@testable import SwipeFeed

final class FeedViewModelTests: XCTestCase {

    private var viewModel: FeedViewModel!
    private var mockService: MockFeedAPIService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockService = MockFeedAPIService()
        viewModel = FeedViewModel(service: mockService)
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
        cancellables = nil
    }
    
    /// Tests successful feed fetching scenario
    func testFetchFeed_Success() {
        // Given
        mockService.shouldReturnError = false
        let expectation = expectation(description: "Feed should be loaded successfully")

        // When
        viewModel.loadFeed()

        // Give time for Combine to emit changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Then
            XCTAssertEqual(self.viewModel.arrFeed.count, self.mockService.mockItems.count, "Expected correct number of feed items")
            XCTAssertNil(self.viewModel.errorMessage, "Error message should be nil")
            XCTAssertFalse(self.viewModel.isLoading, "Loading should stop after data is fetched")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Tests feed fetching failure due to unknown error
    func testFetchFeed_UnknownError() {
        // Given
        mockService.shouldReturnError = true
        mockService.errorType = .unknown
        
        let expectation = XCTestExpectation(description: "Handle unknown error gracefully")
        
        // When
        viewModel.loadFeed()
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                // Then
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(self.viewModel.arrFeed.count, 0)
                XCTAssertFalse(self.viewModel.isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Tests feed fetching failure due to decoding error
    func testFetchFeed_DecodingError() {
        // Given
        mockService.shouldReturnError = true
        mockService.errorType = .decoding
        
        let expectation = XCTestExpectation(description: "Handle decoding error")
        
        // When
        viewModel.loadFeed()
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                // Then
                XCTAssertNotNil(errorMessage)
                XCTAssertTrue(errorMessage?.contains("decode") ?? false)
                XCTAssertTrue(self.viewModel.arrFeed.isEmpty)
                XCTAssertFalse(self.viewModel.isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Tests feed fetching failure due to invalid URL
    func testFetchFeed_InvalidURLError() {
        // Given
        mockService.shouldReturnError = true
        mockService.errorType = .invalidURL
        
        let expectation = XCTestExpectation(description: "Handle invalid URL error")
        
        // When
        viewModel.loadFeed()
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                // Then
                XCTAssertNotNil(errorMessage)
                XCTAssertEqual(self.viewModel.arrFeed.count, 0)
                XCTAssertFalse(self.viewModel.isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    /// Tests loading state toggling correctly
    func testLoadingState_DuringFetch() {
        // Given
        mockService.shouldReturnError = false
        
        let loadingStarted = XCTestExpectation(description: "Loading state is true when fetch starts")
        let loadingStopped = XCTestExpectation(description: "Loading state is false when fetch completes")
        
        var stateChanges = 0
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                stateChanges += 1
                if stateChanges == 1 {
                    XCTAssertTrue(isLoading)
                    loadingStarted.fulfill()
                } else if stateChanges == 2 {
                    XCTAssertFalse(isLoading)
                    loadingStopped.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.loadFeed()
        
        wait(for: [loadingStarted, loadingStopped], timeout: 1.5)
    }
    
}
