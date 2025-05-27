//
//  FeedViewModel.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    @Published var arrFeed: [FeedItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: FeedServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: FeedServiceProtocol = FeedAPIService()) {
        self.service = service
    }

    /// Loads feed data using the injected service
    func loadFeed() {
        isLoading = true
        errorMessage = nil

        service.fetchFeed()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] items in
                self?.arrFeed = items
            }
            .store(in: &cancellables)
    }
}

extension FeedViewModel {
    static var mock: FeedViewModel {
        let vm = FeedViewModel(service: MockFeedAPIService())
        vm.arrFeed = [
            FeedItem(id: 1, title: "Title 1", subtitle: "Sub 1", content: "Content 1"),
            FeedItem(id: 2, title: "Title 2", subtitle: "Sub 2", content: "Content 2")
        ]
        return vm
    }
}

