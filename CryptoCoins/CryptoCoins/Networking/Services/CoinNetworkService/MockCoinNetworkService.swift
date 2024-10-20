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
        let mockCoins = [
            Coin(id: "asdf", symbol: "", name: "", image: "", currentPrice: 0, lastUpdated: ""),
            Coin(id: "asdf2", symbol: "", name: "", image: "", currentPrice: 0, lastUpdated: ""),
            Coin(id: "asdf3", symbol: "", name: "", image: "", currentPrice: 0, lastUpdated: ""),
            Coin(id: "asdf4", symbol: "", name: "", image: "", currentPrice: 0, lastUpdated: "")
        ]
        completion(.success(mockCoins))
    }
    
    func fetchDetailForCoin(with id: String, completion: @escaping (Result<CoinDetail, Error>) -> Void) {
        let mockCoinDetail = CoinDetail(id: "", symbol: "", name: "")
        completion(.success(mockCoinDetail))
    }
}
