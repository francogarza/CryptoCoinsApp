//
//  CoordinatorView.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI

/// A SwiftUI view that integrates with the Coordinator to manage navigation.
///
/// It uses a `NavigationStack` binded to the Coordinator's path and handles page routing.
struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    init(coordinator: Coordinator = Coordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .list)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}
