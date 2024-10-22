//
//  MockCoinNetworkServiceTests.swift
//  CryptoCoinsTests
//
//  Created by Franco Garza on 19/10/24.
//

import XCTest
@testable import CryptoCoins

final class MockCoinNetworkServiceTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }
    
    func test_MockCoinDataService_fetchCoins_doesReturnValues() {
        // Given
        let dataService = MockCoinNetworkService(urlString: "Mock")
        
        // When
        var items: [Coin] = []
        let expectation = XCTestExpectation()
        
        dataService.fetchCoins { result in
            switch result {
            case .success(let coins):
                items = coins
                expectation.fulfill()
            case .failure:
                XCTFail("Expecting completion to return values but returned failure")
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(items, dataService.coins)
    }
    
    func test_MockCoinDataService_fetchCoins_doesReturnInvalidURLError() {
        // Given
        let dataService = MockCoinNetworkService(urlString: "BadURL")
        
        // When
        let coins: [Coin]? = nil
        let expectation = XCTestExpectation()
        
        dataService.fetchCoins { result in
            switch result {
            case .success:
                XCTFail("Expecting completion to return failure but returned success")
            case .failure(let error):
                if error as? URLError == URLError(.badURL) {
                    expectation.fulfill()
                }
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(coins, dataService.coins)
    }
    
    func test_MockCoinDataService_fetchCoinDetail_doesReturnValues() {
        // Given
        let dataService = MockCoinNetworkService(urlString: "Mock")
        
        // When
        var coinDetail: CoinDetail?
        let expectation = XCTestExpectation()
        
        dataService.fetchDetailForCoin(with: "") { result in
            switch result {
            case .success(let coinDetailResult):
                coinDetail = coinDetailResult
                expectation.fulfill()
            case .failure:
                XCTFail("Expecting completion to return values but returned failure")
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(coinDetail, dataService.coinDetail)
    }
    
    func test_MockCoinDataService_fetchCoinDetail_doesReturnInvalidURLError() {
        // Given
        let dataService = MockCoinNetworkService(urlString: "BadURL")
        
        // When
        let coinDetail: CoinDetail? = nil
        let expectation = XCTestExpectation()
        
        dataService.fetchCoins { result in
            switch result {
            case .success:
                XCTFail("Expecting completion to return failure but returned success")
            case .failure(let error):
                if error as? URLError == URLError(.badURL) {
                    expectation.fulfill()
                }
            }
        }
        
        // Then
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(coinDetail, dataService.coinDetail)
    }

}
