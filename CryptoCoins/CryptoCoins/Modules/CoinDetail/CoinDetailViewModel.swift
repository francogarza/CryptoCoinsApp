//
//  CoinDetailViewModel.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

extension CoinDetailView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var coinDetail: CoinDetail?
        private var coinId: String
        private var coinService: CoinService
        
        init(coinService: CoinService, coinId: String) {
            self.coinService = coinService
            self.coinId = coinId
        }
        
        func viewDidAppear() {
            coinService.fetchDetailForCoin(with: coinId) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let coinDetail):
                        self.coinDetail = coinDetail
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        }
    }
}
