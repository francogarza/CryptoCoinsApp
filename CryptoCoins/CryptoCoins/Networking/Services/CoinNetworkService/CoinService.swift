//
//  CoinService.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Defines a service for fetching coin data.
protocol CoinService {
    /// - Parameter completion: A closure returning either a list of `Coin` objects or an error.
    func fetchCoins(completion: @escaping (Result<[Coin], Error>) -> Void)
}
