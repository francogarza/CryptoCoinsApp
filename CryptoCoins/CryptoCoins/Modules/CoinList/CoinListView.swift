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
        VStack(spacing: 0) {
            header
                .zIndex(1)
            
            contentView
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
    }
    
    var header: some View {
        VStack(spacing: 20) {
            HStack(spacing: 10) {
                Image("Logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("Crypto Coins")
                    .robotoFont(size: 24, weight: .bold)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            searchBar
        }
        .padding(20)
        .background {
            Rectangle()
                .foregroundStyle(.background)
                .shadow(color: Color(.systemGray4), radius: 4)
                .mask {
                    Rectangle()
                        .padding(.bottom, -10)
                }
        }
    }
    
    var searchBar: some View {
        Group {
            if !viewModel.isShowingNetworkError {
                TextField("Search for a coin", text: $viewModel.searchText)
                    .robotoFont(size: 14, weight: .bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(Color(.systemGray6))
                    }
            }
        }
    }
    
    var contentView: some View {
        Group {
            if !viewModel.isShowingNetworkError {
                if !viewModel.isLoading {
                    coinList
                } else {
                    loadingView
                }
            } else {
                scrollViewNetworkError
            }
        }
    }
    
    var coinList: some View {
        ScrollView {
            if !viewModel.filteredCoins.isEmpty {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.filteredCoins, id: \.id) { coin in
                        rowViewFor(coin)
                    }
                }
                .padding(20)
            } else {
                VStack(spacing: 10) {
                    Text("Couldn't find any coins with that name")
                        .robotoFont(size: 16)
                        .foregroundStyle(Color(.textSecondary))
                    Image(systemName: "exclamationmark.magnifyingglass")
                        .robotoFont(size: 20)
                        .foregroundStyle(Color(.textSecondary))
                }
                .padding(.vertical, 40)
            }
        }
        .refreshable {
            viewModel.fetchCoins()
        }
    }
    
    var scrollViewNetworkError: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Sorry for the inconvenience, but we can't reach the servers at the moment")
                    .multilineTextAlignment(.center)
                    .robotoFont(size: 16)
                    .foregroundStyle(Color(.textSecondary))
                
                Text("Please try again later by pulling down to refresh")
                    .robotoFont(size: 12, weight: .italic)
                    .foregroundStyle(Color(.textSecondary))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Image(systemName: "network.slash")
                    .robotoFont(size: 20)
                    .foregroundStyle(Color(.textSecondary))
            }
            .padding(40)
        }
        .refreshable {
            viewModel.fetchCoins()
        }
    }
    
    var loadingView: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.background)
            ProgressView()
        }
    }
    
    func rowViewFor(_ coin: Coin) -> some View {
        Button {
            coordinator.push(page: .detailForCoinWith(id: coin.id))
        } label: {
            HStack(spacing: 0) {
                Text(String(coin.marketCapRank))
                    .robotoFont(size: 12)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
                    .frame(width: 14, alignment: .leading)
                
                Image.loadFrom(urlString: coin.image)
                    .frame(width: 25, height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .padding(5)
                    .background {
                        Circle()
                            .foregroundStyle(.background)
                            .shadow(color: Color(.systemGray4), radius: 4)
                    }
                    .padding(.horizontal, 15)
                
                VStack(spacing: 5) {
                    Text(coin.symbol.uppercased())
                        .robotoFont(size: 14, weight: .bold)
                        .foregroundStyle(Color.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(coin.marketCap.formattedAsShortCurrency())
                        .robotoFont(size: 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.secondaryText)
                }
                .padding(.horizontal, 5)
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text(coin.currentPrice.formattedAsCurrency())
                        .robotoFont(size: 14, weight: .bold)
                        .foregroundStyle(Color.text)
                    Text(coin.lastUpdated.stringDateToStringWith(format: "h:mm:ss a"))
                        .robotoFont(size: 12, weight: .italic)
                        .foregroundStyle(Color.secondaryText)
                }
            }
            .cardViewStyle(horizontalInset: 20, verticalInset: 15)
        }
    }
}

#Preview {
    CoinListView(viewModel: CoinListView.ViewModel(coinService: MockCoinNetworkService()))
}
