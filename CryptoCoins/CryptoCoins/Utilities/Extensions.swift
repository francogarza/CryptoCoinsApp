//
//  Extensions.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//
import SwiftUI

// MARK: Custom View Modifiers

// Roboto Font Modifier
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
            .font(.custom(robotoFontName(for: weight), size: size, relativeTo: .body))
    }
}
extension View {
    func robotoFont(size: CGFloat, weight: RobotoFontModifier.FontWeight = .regular) -> some View {
        modifier(RobotoFontModifier(size: size, weight: weight))
    }
}

// Card View Modifier
struct CardViewModifier: ViewModifier {
    var horizontalInset: CGFloat
    var verticalInset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalInset)
            .padding(.vertical, verticalInset)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(.background)
                    .shadow(color: Color(.systemGray4), radius: 4)
            }
    }
}
extension View {
    func cardViewStyle(horizontalInset: CGFloat, verticalInset: CGFloat) -> some View {
        modifier(CardViewModifier(horizontalInset: horizontalInset, verticalInset: verticalInset))
    }
}

// Back Swipe Modifier
struct BackSwipeGestureModifier: ViewModifier {
    @Binding var dragOffset: CGSize
    var coordinator: Coordinator

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width > 0 {
                            dragOffset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        if dragOffset.width > 100 {
                            if !coordinator.path.isEmpty {
                                coordinator.pop()
                            }
                        }
                        dragOffset = .zero
                    }
            )
    }
}
extension View {
    func backSwipeGesture(dragOffset: Binding<CGSize>, coordinator: Coordinator) -> some View {
        self.modifier(BackSwipeGestureModifier(dragOffset: dragOffset, coordinator: coordinator))
    }
}

// MARK: String
extension String {
    func stringDateToStringWith(format: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: self) else {
            return "Invalid date"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}

// MARK: Date
extension Date {
    func toStringWith(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

// MARK: Image
extension Image {
    static func loadFrom(urlString: String) -> some View {
        return AsyncImage(urlString: urlString)
    }
    
    private struct AsyncImage: View {
        let urlString: String
        
        @State private var loadedImage: UIImage?
        
        var body: some View {
            if let uiImage = loadedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(Color(.systemGray6))
                    }
                    .onAppear {
                        loadImage(from: urlString)
                    }
            }
        }
        
        private func loadImage(from urlString: String) {
            guard let url = URL(string: urlString) else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let uiImage = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.loadedImage = uiImage
                }
            }.resume()
        }
    }
}

// MARK: Color
extension Color {
    static let primary = Color("Primary")
    static let text = Color("TextPrimary")
    static let secondaryText = Color("TextSecondary")
}

// MARK: Double
extension Double {
    func formattedAsShortCurrency() -> String {
        let number = Double(self)
        let trillion = number / 1_000_000_000_000
        let billion = number / 1_000_000_000
        let million = number / 1_000_000
        let thousand = number / 1_000
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if trillion >= 1.0 {
            return "$\(formatter.string(from: NSNumber(value: trillion)) ?? "0") T"
        } else if billion >= 1.0 {
            return "$\(formatter.string(from: NSNumber(value: billion)) ?? "0") B"
        } else if million >= 1.0 {
            return "$\(formatter.string(from: NSNumber(value: million)) ?? "0") M"
        } else if thousand >= 1.0 {
            return "$\(formatter.string(from: NSNumber(value: thousand)) ?? "0") K"
        } else {
            return "$\(formatter.string(from: NSNumber(value: self)) ?? "0")"
        }
    }
    
    func formattedAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = ","
        
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? "\(self)"
    }
}

// MARK: URLQueryItem
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
