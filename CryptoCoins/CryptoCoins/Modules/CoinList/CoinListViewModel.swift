//
//  CoinListViewModel.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

extension CoinListView {
    @MainActor final class ViewModel: ObservableObject {
        private var coinService: CoinService
        
        init(coinService: CoinService) {
            self.coinService = coinService
        }
        
        func viewDidAppear() {
            fetchCoins()
        }
        
        func fetchCoins() {
            coinService.fetchCoins { result in
                switch result {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
}
