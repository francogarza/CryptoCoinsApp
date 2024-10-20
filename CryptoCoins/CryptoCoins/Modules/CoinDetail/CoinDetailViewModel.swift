//
//  CoinDetailViewModel.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

extension CoinDetailView {
    @MainActor final class ViewModel: ObservableObject {
        private var coinService: CoinService
        
        init(coinService: CoinService) {
            self.coinService = coinService
        }
    }
}
