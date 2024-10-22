//
//  SortOption.swift
//  CryptoCoins
//
//  Created by Franco Garza on 21/10/24.
//

import Foundation

protocol SortOption {
    var type: SortOptionType { get }
    var title: String { get }
    var order: Order { get set }
}

struct SortByRank: Equatable, SortOption {
    var type: SortOptionType = .rank
    var title: String = "Rank"
    var order: Order = .unselected
}

struct SortByPrice: SortOption {
    var type: SortOptionType = .price
    var title: String = "Price"
    var order: Order = .unselected
}

struct SortByAlphabetically: SortOption {
    var type: SortOptionType = .alphabetically
    var title: String = "A -> Z"
    var order: Order = .unselected
}

enum SortOptionType {
    case rank, price, alphabetically
}

enum Order: CaseIterable {
    case unselected, ascending, descending
    
    mutating func next() {
        let allCases = Self.allCases
        if let currentIndex = allCases.firstIndex(of: self) {
            let nextIndex = allCases.index(after: currentIndex)
            self = allCases[nextIndex == allCases.endIndex ? allCases.startIndex : nextIndex]
        }
    }
}
