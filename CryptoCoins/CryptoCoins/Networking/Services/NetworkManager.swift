//
//  NetworkManager.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI

/// Manages network requests.
class NetworkManager: APIService {
    /// - Parameter endpoint: The API endpoint to request data from.
    /// - Parameter completion: A completion handler returning either a decoded object or an error.
    func performRequest<T>(endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        guard let request = endpoint.buildURLRequest() else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(URLError(.cannotDecodeContentData)))
            }
        }.resume()
    }
}
