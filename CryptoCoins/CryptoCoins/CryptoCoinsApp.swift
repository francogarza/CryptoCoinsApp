//
//  CryptoCoinsApp.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI

/// The entry point of the CryptoCoins app.
///
/// Initializes and launches the main app view, which is managed by the coordinator.
@main
struct CryptoCoinsApp: App {
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
    }
}
