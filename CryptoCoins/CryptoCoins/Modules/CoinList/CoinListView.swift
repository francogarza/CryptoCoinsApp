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
            Text("CoinListView")
            
            Button {
                coordinator.push(page: .detail)
            } label: {
                Text("move to detail")
            }
        }
        .padding()
        .onAppear {
            viewModel.viewDidAppear()
        }
    }
}

#Preview {
    CoinListView(viewModel: CoinListView.ViewModel(coinService: MockCoinNetworkService()))
}
