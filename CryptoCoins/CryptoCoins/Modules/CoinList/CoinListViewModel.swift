//
//  CoinListViewModel.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

extension CoinListView {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var filteredCoins: [Coin] = []
        @Published var searchText: String = "" {
            didSet {
                searchCoins()
            }
        }
        private var coins = [Coin]()
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
                case .success(let coins):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.coins = coins
                        self.filteredCoins = self.coins
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        
        // Filter coins based on search text
        func searchCoins() {
            if searchText.isEmpty {
                filteredCoins = coins
            } else {
                filteredCoins = coins.filter {
                    $0.name.lowercased().contains(searchText.lowercased()) ||
                    $0.symbol.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }
}
