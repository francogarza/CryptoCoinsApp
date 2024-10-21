//
//  ContentView.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI

struct CoinListView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            searchBar
            
            coinList
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
    }
    
    var searchBar: some View {
        TextField("Search for a coin", text: $viewModel.searchText)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
    
    var coinList: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(viewModel.filteredCoins.enumerated()), id: \.offset) { index, coin in
                    rowViewFor(coin, at: index)
                }
            }
        }
    }
    
    func rowViewFor(_ coin: Coin, at index: Int) -> some View {
        HStack {
            Text(String(index + 1))
            Text(coin.name)
            Spacer()
            Text(String(format: "%.2f", coin.currentPrice))
        }
        .onTapGesture {
            coordinator.push(page: .detailForCoinWith(id: coin.id))
        }
    }
}

#Preview {
    CoinListView(viewModel: CoinListView.ViewModel(coinService: MockCoinNetworkService()))
}
