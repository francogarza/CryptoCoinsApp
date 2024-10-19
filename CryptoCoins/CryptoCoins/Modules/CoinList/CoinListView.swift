//
//  ContentView.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI

struct CoinListView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
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
    }
}

#Preview {
    CoinListView()
}
