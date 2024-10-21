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
        guard let url = Bundle.main.url(forResource: "MockCoinsResponse", withExtension: "json") else {
            print("Failed to find MockCoinsResponse.json in the bundle.")
            completion(.failure(NetworkError.noData))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let coins = try decoder.decode([Coin].self, from: data)
            
            completion(.success(coins))
        } catch {
            print("Error decoding JSON: \(error)")
            completion(.failure(NetworkError.decodingFailed))
        }
    }
    
    func fetchDetailForCoin(with id: String, completion: @escaping (Result<CoinDetail, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "MockCoinDetailResponse", withExtension: "json") else {
            print("Failed to find MockCoinDetailResponse.json in the bundle.")
            completion(.failure(NetworkError.noData))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let coinDetail = try decoder.decode(CoinDetail.self, from: data)
            
            completion(.success(coinDetail))
        } catch {
            print("Error decoding JSON: \(error)")
            completion(.failure(NetworkError.decodingFailed))
        }
    }
    
    func fetchPriceHistoryForCoin(with id: String, completion: @escaping (Result<PriceHistory, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "MockCoinPriceHistory", withExtension: "json") else {
            print("Failed to find MockCoinPriceHistory.json in the bundle.")
            completion(.failure(NetworkError.noData))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let priceHistory = try decoder.decode(PriceHistory.self, from: data)
            
            completion(.success(priceHistory))
        } catch {
            print("Error decoding JSON: \(error)")
            completion(.failure(NetworkError.decodingFailed))
        }
    }
}
