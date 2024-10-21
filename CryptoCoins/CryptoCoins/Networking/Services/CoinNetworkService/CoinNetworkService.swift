//
//  CoinList+Service.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Fetches coin-related data from the network.
class CoinNetworkService: CoinService {
    
    private let networkManager: APIService

    init(networkManager: APIService) {
        self.networkManager = networkManager
    }

    /// - Parameter completion: A closure with either a list of `Coin` or an error.
    func fetchCoins(completion: @escaping (Result<[Coin], Error>) -> Void) {
        let endpoint = CoinGeckoEndpoint.topCoins(vsCurrency: "usd", perPage: 20, page: 1)
        networkManager.performRequest(endpoint: endpoint, completion: completion)
    }
    
    /// - Parameter completion: A closure with either a `CoindDetail` or an error.
    func fetchDetailForCoin(with id: String, completion: @escaping (Result<CoinDetail, Error>) -> Void) {
        let endpoint = CoinGeckoEndpoint.coinDetail(coinId: id)
        networkManager.performRequest(endpoint: endpoint, completion: completion)
    }
    
    func fetchPriceHistoryForCoin(with id: String, completion: @escaping (Result<PriceHistory, Error>) -> Void) {
        let endpoint = CoinGeckoEndpoint.coinPriceHistory(vsCurrency: "usd", id: id, days: 7)
        networkManager.performRequest(endpoint: endpoint, completion: completion)
    }
}
