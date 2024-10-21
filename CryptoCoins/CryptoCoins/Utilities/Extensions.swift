//
//  Extensions.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import Foundation

extension URLQueryItem {
    /// Converts a dictionary to an array of query items.
    /// - Parameter dictionary: Dictionary with keys as query parameter names and optional values.
    /// - Returns: An array of `URLQueryItem` ignoring nil values.
    static func from(dictionary: [String: String?]) -> [URLQueryItem] {
        return dictionary.compactMap { key, value in
            guard let value = value else { return nil }
            return URLQueryItem(name: key, value: value)
        }
    }
}

struct RobotoFontModifier: ViewModifier {
    var size: CGFloat
    var weight: FontWeight

    enum FontWeight {
        case regular
        case bold
        case light
        case medium
        case italic
    }

    private func robotoFontName(for weight: FontWeight) -> String {
        switch weight {
        case .regular:
            return "Roboto-Regular"
        case .bold:
            return "Roboto-Bold"
        case .light:
            return "Roboto-Light"
        case .medium:
            return "Roboto-Medium"
        case .italic:
            return "Roboto-Italic"
        }
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(robotoFontName(for: weight), size: size))
    }
}

extension View {
    func robotoFont(size: CGFloat, weight: RobotoFontModifier.FontWeight = .regular) -> some View {
        self.modifier(RobotoFontModifier(size: size, weight: weight))
    }
}
