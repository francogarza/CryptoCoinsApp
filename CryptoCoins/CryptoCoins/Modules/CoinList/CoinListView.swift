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
                    sortOptions
                    
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
    
    var sortOptions: some View {
        HStack(spacing: 10) {
            Text("Sort by: ")
                .robotoFont(size: 14, weight: .bold)
                .foregroundStyle(Color(.textSecondary))
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(viewModel.sortOptions, id: \.type) { sort in
                        viewFor(sort)
                    }
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

private extension CoinListView {
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
    
    func viewFor(_ sort: SortOption) -> some View {
        Group {
            if sort.order == .unselected {
                viewForUnselected(sort)
            } else {
                viewForSelected(sort)
            }
        }
    }
    
    func viewForUnselected(_ sort: SortOption) -> some View {
        HStack(spacing: 10) {
            Text(sort.title)
                .robotoFont(size: 14, weight: .medium)
                .fixedSize(horizontal: true, vertical: false)
        }
        .foregroundStyle(Color(.textSecondary))
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(lineWidth: 2)
                .foregroundStyle(Color(.textSecondary))
        }
        .onTapGesture {
            viewModel.didTap(sort)
        }
    }
    
    func viewForSelected(_ sort: SortOption) -> some View {
        HStack(spacing: 10) {
            Text(sort.title)
                .robotoFont(size: 14, weight: .bold)
                .fixedSize(horizontal: true, vertical: false)
            if sort.order == .descending {
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .bold))
            } else if sort.order == .ascending {
                Image(systemName: "chevron.up")
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .foregroundStyle(.white)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.accent.opacity(0.8))
        }
        .onTapGesture {
            viewModel.didTap(sort)
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
