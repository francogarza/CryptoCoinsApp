//
//  CoinDetailView.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI

struct CoinDetailView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if let coinDetail = viewModel.coinDetail {
                Text(coinDetail.name)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
    }
}

#Preview {
    CoinDetailView(viewModel: CoinDetailView.ViewModel(coinService: MockCoinNetworkService(), coinId: "bitcoin"))
}
