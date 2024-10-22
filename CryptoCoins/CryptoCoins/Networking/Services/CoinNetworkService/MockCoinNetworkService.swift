//
//  MockCoinService.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Mock service for fetching coin data for testing purposes.
class MockCoinNetworkService: CoinService {
    var urlString: String
    var coins: [Coin]?
    var coinDetail: CoinDetail?
    
    init(urlString: String, coins: [Coin]? = nil) {
        self.urlString = urlString
        self.coins = coins
    }
    
    /// - Parameter completion: A closure returning mock `Coin` data or an error.
    func fetchCoins(completion: @escaping (Result<[Coin], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: urlString, withExtension: "json") else {
            print("Failed to find \(urlString) in the bundle.")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let coins = try decoder.decode([Coin].self, from: data)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.coins = coins
                completion(.success(coins))
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(.failure(URLError(.cannotDecodeContentData)))
        }
    }
    
    func fetchDetailForCoin(with id: String, completion: @escaping (Result<CoinDetail, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: urlString, withExtension: "json") else {
            print("Failed to find MockCoinDetailResponse.json in the bundle.")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let coinDetail = try decoder.decode(CoinDetail.self, from: data)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.coinDetail = coinDetail
                completion(.success(coinDetail))
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(.failure(URLError(.cannotDecodeContentData)))
        }
    }
    
    func fetchPriceHistoryForCoin(with id: String, completion: @escaping (Result<PriceHistory, Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "\(urlString)_PriceHistory", withExtension: "json") else {
            print("Failed to find MockCoinPriceHistory.json in the bundle.")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let priceHistory = try decoder.decode(PriceHistory.self, from: data)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(priceHistory))
            }
        } catch {
            print("Error decoding JSON: \(error)")
            completion(.failure(URLError(.cannotDecodeContentData)))
        }
    }
}
