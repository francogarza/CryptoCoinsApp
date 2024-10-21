//
//  PriceHistory.swift
//  CryptoCoins
//
//  Created by Franco Garza on 20/10/24.
//

import Foundation

struct PriceHistory: Decodable {
    let prices: [[Double]]
    
    // first value is a date that can be formatted like so
    func convertToReadableDates() -> [Date] {
        return prices.map { Date(timeIntervalSince1970: $0[0] / 1000) }
    }
    
    // second value are the prices
    func extractPrices() -> [Double] {
        return prices.map { $0[1] }
    }
}
