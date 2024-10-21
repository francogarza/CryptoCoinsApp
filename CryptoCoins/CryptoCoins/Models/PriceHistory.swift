//
//  PriceHistory.swift
//  CryptoCoins
//
//  Created by Franco Garza on 20/10/24.
//

import SwiftUI

struct PriceHistory: Decodable {
    let prices: [[Double]]
    let dates: [Date]
    let extractedPrices: [Double]
    let minPrice: Double
    let maxPrice: Double
    let color: Color
    let lastSevenDays: [Date] = {
            let calendar = Calendar.current
            let today = Date()
            return (0...7).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }.reversed()
        }()
    let yAxisValues: [Double]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.prices = try container.decode([[Double]].self, forKey: .prices)
        dates = prices.map { Date(timeIntervalSince1970: $0[0] / 1000) }
        extractedPrices = prices.map { $0[1] }
        minPrice = extractedPrices.min() ?? 0
        maxPrice = extractedPrices.max() ?? 0
        color = extractedPrices.first ?? 0 > extractedPrices.last ?? 0 ? .red : .green
        let step = abs(maxPrice - minPrice).rounded(.down) / 3
        yAxisValues = [minPrice, minPrice + step, minPrice + step + step, maxPrice]
        
    }
    
    enum CodingKeys: String, CodingKey {
        case prices
    }

}
