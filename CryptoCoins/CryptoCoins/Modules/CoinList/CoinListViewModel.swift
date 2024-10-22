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
        @Published var isLoading: Bool = true
        @Published var isShowingNetworkError: Bool = false
        @Published var sortOptions: [SortOption] {
            didSet {
                sortCoins()
            }
        }
        private var coins = [Coin]()
        private var coinService: CoinService
        private var selectedSort: SortOption? {
            return sortOptions.first(where: { $0.order != .unselected })
        }
        
        init(coinService: CoinService) {
            self.coinService = coinService
            sortOptions = [SortByRank(order: .ascending), SortByPrice(), SortByAlphabetically()]
            fetchCoins()
        }
        
        func fetchCoins() {
            isLoading = true
            coinService.fetchCoins { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let coins):
                        self.coins = coins
                        self.filteredCoins = coins
                        sortCoins()
                        isShowingNetworkError = false
                    case .failure(let failure):
                        isShowingNetworkError = true
                        print(failure)
                    }
                    isLoading = false
                }
            }
        }
        
        func didTap(_ sort: SortOption) {
            for index in sortOptions.indices {
                if sortOptions[index].type == sort.type {
                    sortOptions[index].order.next()
                } else {
                    sortOptions[index].order = .unselected
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
        
        func sortCoins() {
            if let selectedSort {
                switch selectedSort.type {
                case .rank:
                    sortByRank(with: selectedSort.order)
                case .price:
                    sortByPrice(with: selectedSort.order)
                case .alphabetically:
                    sortByAlphabetically(with: selectedSort.order)
                }
            } else {
                coins.sort(by: { $0.marketCap > $1.marketCap })
            }
            searchCoins()
        }
        
        func sortByRank(with order: Order) {
            switch order {
            case .unselected:
                break
            case .ascending:
                coins.sort(by: { $0.marketCap > $1.marketCap })
            case .descending:
                coins.sort(by: { $0.marketCap < $1.marketCap })
            }
        }
        
        func sortByPrice(with order: Order) {
            switch order {
            case .unselected:
                break
            case .ascending:
                coins.sort(by: { $0.currentPrice > $1.currentPrice })
            case .descending:
                coins.sort(by: { $0.currentPrice < $1.currentPrice })
            }
        }
        
        func sortByAlphabetically(with order: Order) {
            switch order {
            case .unselected:
                break
            case .ascending:
                coins.sort(by: { $0.name < $1.name })
            case .descending:
                coins.sort(by: { $0.name > $1.name })
            }
        }
    }
}
