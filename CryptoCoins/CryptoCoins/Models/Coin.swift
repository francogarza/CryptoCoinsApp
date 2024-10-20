//
//  Coin.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Represents a cryptocurrency coin with its key properties.
///
/// The `Coin` struct conforms to `Identifiable` and `Decodable` protocols
struct Coin: Identifiable, Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let lastUpdated: String
}
