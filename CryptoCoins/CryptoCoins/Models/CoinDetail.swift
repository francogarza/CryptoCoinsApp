//
//  CoinDetail.swift
//  CryptoCoins
//
//  Created by Franco Garza on 20/10/24.
//

import Foundation

struct CoinDetail: Identifiable, Decodable {
    let id: String
    let symbol: String
    let name: String
}
