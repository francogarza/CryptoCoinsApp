//
//  Extensions.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

extension URLQueryItem {
    /// Converts a dictionary to an array of query items.
    /// - Parameter dictionary: Dictionary with keys as query parameter names and optional values.
    /// - Returns: An array of `URLQueryItem` ignoring nil values.
    static func from(dictionary: [String: String?]) -> [URLQueryItem] {
        return dictionary.compactMap { key, value in
            guard let value = value else { return nil }
            return URLQueryItem(name: key, value: value)
        }
    }
}
