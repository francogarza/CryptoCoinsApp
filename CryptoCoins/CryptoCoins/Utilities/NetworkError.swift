//
//  NetworkError.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

/// Represents network-related errors.
enum NetworkError: LocalizedError {
    case invalidURL, noData, decodingFailed, networkError(Error)

    /// Describes the error.
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data received."
        case .decodingFailed: return "Decoding failed."
        case .networkError(let error): return error.localizedDescription
        }
    }
}
