//
//  Coordinator.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI

/// Defines the possible navigation pages in the app.
enum AppPages: Hashable {
    case list
    case detail
}

/// A coordinator that manages navigation flow throughout the app.
///
/// The `Coordinator` class is responsible for pushing and popping views in the navigation stack.
/// It uses a `NavigationPath` to track the navigation state and supports building views based on the selected page.
class Coordinator: ObservableObject {
    
    /// Tracks the navigation path of the app.
    ///
    /// The `path` is updated when pages are pushed or popped in the `NavigationStack`.
    @Published var path: NavigationPath = NavigationPath()
    
    /// Appends a new page to the navigation path.
    ///
    /// - Parameter page: The page to append to the path.
    func push(page: AppPages) {
        path.append(page)
    }
    
    /// Removes the last page from the navigation path.
    ///
    /// This method navigates backward by popping the most recent page.
    func pop() {
        path.removeLast()
    }
    
    /// Clears all pages in the navigation path, returning to the root view.
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Builds and returns a view for the specified page.
    ///
    /// - Parameter page: The `AppPages` enum representing the view to display.
    /// - Returns: A SwiftUI view corresponding to the given page.
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .list:
            CoinListView()
        case .detail:
            CoinDetailView()
        }
    }
}
