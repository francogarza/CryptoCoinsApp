//
//  CoinGeckoAPI.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Enum representing CoinGecko API endpoints.
/// - `topCoins`: Fetches the top coins with specific parameters.
/// - `Coindetail`: Fetches the given coin's detail with specific parameters.
enum CoinGeckoEndpoint: APIEndpoint {
    case topCoins(vsCurrency: String, perPage: Int, page: Int)
    case coinDetail(coinId: String)
    case coinPriceHistory(vsCurrency: String, id: String, days: Int)

    var baseURL: String {
        return "https://api.coingecko.com/api/v3"
    }

    var path: String {
        switch self {
        case .topCoins:
            return "/coins/markets"
        case .coinDetail(let coinID):
            return "/coins/\(coinID)"
        case .coinPriceHistory(_, let id, _):
            return "/coins/\(id)/market_chart"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .topCoins(let vsCurrency, let perPage, let page):
            return URLQueryItem.from(dictionary: [
                "vs_currency": vsCurrency,
                "per_page": "\(perPage)",
                "page": "\(page)"
            ])
        case .coinDetail:
            return nil
        case .coinPriceHistory(let vsCurrency, id: let id, days: let days):
            return URLQueryItem.from(dictionary: [
                "vs_currency": vsCurrency,
                "id": id,
                "days": "\(days)"
            ])
        }
    }
}
