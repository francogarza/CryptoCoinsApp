//
//  CoinDetail.swift
//  CryptoCoins
//
//  Created by Franco Garza on 20/10/24.
//

import Foundation

struct CoinDetail: Identifiable, Decodable {
    let id: String
    let name: String
    let image: Image
    let marketData: MarketData
    
    var marketCap: String { marketData.marketCap.usd.formattedAsShortCurrency() }
    var totalVolume: String { marketData.totalVolume.usd.formattedAsCurrency() }
    var high24H: String { marketData.priceChange24H.formattedAsShortCurrency() }
    var low24H: String { marketData.low24H.usd.formattedAsShortCurrency() }
    var priceChange24H: String { marketData.priceChange24H.formattedAsShortCurrency() }
    
    struct MarketData: Decodable {
        let marketCap: PriceByCurrency
        let totalVolume: PriceByCurrency
        let high24H: PriceByCurrency
        let low24H: PriceByCurrency
        let priceChange24H: Double
    }
    
    struct PriceByCurrency: Decodable {
        let usd: Double
    }
    
    struct Image: Decodable {
        let large: String
    }
}
