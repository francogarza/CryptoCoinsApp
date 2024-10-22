//
//  CoinListViewModelTests.swift
//  CryptoCoinsTests
//
//  Created by Franco Garza on 19/10/24.
//

import XCTest
@testable import CryptoCoins

final class CoinListViewModelTests: XCTestCase {
    var viewModel: CoinListView.ViewModel?

    @MainActor override func setUpWithError() throws {
        let dataService = MockCoinNetworkService(urlString: "MockCoinsResponse")
        viewModel = CoinListView.ViewModel(coinService: dataService)
    }

    override func tearDownWithError() throws { 
        viewModel = nil
    }
    
    @MainActor func test_CoinListViewModel_didTapSort_doesInteractSuccessfully() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        // When
        var sortOptions = viewModel.sortOptions
        let expectation = XCTestExpectation()
        
        viewModel.didTap(viewModel.selectedSort ?? SortByRank())
        
        if let sort = sortOptions.first(where: {$0.order != .unselected}) {
            for index in sortOptions.indices {
                if sortOptions[index].type == sort.type {
                    sortOptions[index].order.next()
                } else {
                    sortOptions[index].order = .unselected
                }
            }
        }
        
        // Then
        if let option1 = sortOptions.first(where: { $0.order == .unselected}) as? SortByRank,
           let option2 = viewModel.selectedSort as? SortByRank {
            XCTAssertEqual(option1, option2)
        }
    }
    
    @MainActor func test_CoinListViewModel_sortCoins_doesSortSuccessfully() {
        // Given
        guard let viewModel = viewModel else {
            XCTFail()
            return
        }
        
        var coins = viewModel.coins
        let expectation = XCTestExpectation()
        // When
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            coins = viewModel.coins
            coins.sort(by: { $0.marketCap < $1.marketCap })
            
            viewModel.didTap(viewModel.selectedSort ?? SortByRank())
            expectation.fulfill()
        }
        
        // When
        wait(for: [expectation], timeout: 4)
        XCTAssertEqual(coins, viewModel.coins)
    }
}
