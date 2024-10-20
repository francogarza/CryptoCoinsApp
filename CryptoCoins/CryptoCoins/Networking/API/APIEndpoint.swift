//
//  APIEndpoint.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Defines an API endpoint with its URL components.
protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    
    /// - Returns: A URLRequest for the endpoint.
    func buildURLRequest() -> URLRequest?
}

extension APIEndpoint {
    func buildURLRequest() -> URLRequest? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url.flatMap { URLRequest(url: $0) }
    }
}
