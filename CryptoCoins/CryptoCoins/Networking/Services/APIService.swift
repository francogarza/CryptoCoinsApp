//
//  APIClient.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Defines a service for performing network requests.
protocol APIService {
    /// - Parameter endpoint: The API endpoint to request data from.
    /// - Parameter completion: A completion handler returning either a decoded object or an error.
    func performRequest<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void)
}
