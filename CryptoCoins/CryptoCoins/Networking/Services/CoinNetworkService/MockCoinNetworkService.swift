//
//  MockCoinService.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Mock service for fetching coin data for testing purposes.
class MockCoinNetworkService: CoinService {
    /// - Parameter completion: A closure returning mock `Coin` data or an error.
    func fetchCoins(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let mockCoins = [Coin]()
        completion(.success(mockCoins))
    }
}
