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
        @Published var priceHistory: PriceHistory?
        @Published var isLoading: Bool = true
        @Published var isShowingNetworkError: Bool = false
        private var coinId: String
        private var coinService: CoinService
        
        init(coinService: CoinService, coinId: String) {
            self.coinService = coinService
            self.coinId = coinId
        }
        
        func viewDidAppear() {
            fetchDetail()
        }
        
        func fetchDetail() {
            isLoading = true
            coinService.fetchDetailForCoin(with: coinId) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let coinDetail):
                        self.coinDetail = coinDetail
                        isShowingNetworkError = false
                    case .failure(let failure):
                        print(failure)
                        isShowingNetworkError = true
                    }
                    isLoading = false
                    fetchGraph()
                }
            }
        }
        
        func fetchGraph() {
            coinService.fetchPriceHistoryForCoin(with: coinId) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let priceHistory):
                        self.priceHistory = priceHistory
                        isShowingNetworkError = false
                    case .failure(let failure):
                        print(failure)
                        isShowingNetworkError = true
                    }
                }
            }
        }
    }
}
