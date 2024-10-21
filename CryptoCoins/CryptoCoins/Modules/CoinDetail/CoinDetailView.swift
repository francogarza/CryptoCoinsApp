//
//  CoinDetailView.swift
//  CryptoCoins
//
//  Created by Franco Garza on 19/10/24.
//

import SwiftUI
import Charts

struct CoinDetailView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject private var viewModel: ViewModel
    @State private var dragOffset: CGSize = .zero
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .zIndex(1)
            
            contentView
        }
        .toolbar(.hidden)
        .backSwipeGesture(dragOffset: $dragOffset, coordinator: coordinator)
        .onAppear {
            viewModel.viewDidAppear()
        }
    }
    
    var header: some View {
        ZStack {
            HStack {
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(.textSecondary))
                        .frame(width: 20, height: 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            
            Text("Coin Detail")
                .foregroundStyle(Color(.textPrimary))
                .robotoFont(size: 16, weight: .bold)
                .frame(maxWidth: .infinity)
                .padding(.top, 4)
        }
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
        GeometryReader { proxy in
            if !viewModel.isLoading {
                coinDetailsContainer(proxy)
            } else {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.background)
                    ProgressView()
                }
            }
        }
    }
    
    func coinDetailsContainer(_ proxy: GeometryProxy) -> some View {
        Group {
            if !viewModel.isShowingNetworkError {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        nameAndImage(proxy)
                        
                        numericDetails
                        
                        detailViewForGraph
                    }
                    .padding(20)
                }
            } else {
                networkErrorScrollView
            }
        }
    }
    
    func nameAndImage(_ proxy: GeometryProxy) -> some View {
        Group {
            if let coinDetail = viewModel.coinDetail {
                VStack(spacing: 10) {
                    Text(coinDetail.name)
                        .robotoFont(size: 32, weight: .bold)
                        .foregroundStyle(Color(.textPrimary))
                    
                    Image.loadFrom(urlString: coinDetail.image.large)
                        .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .padding(30)
                        .background {
                            Circle()
                                .foregroundStyle(.background)
                                .shadow(color: Color(.systemGray4), radius: 4)
                        }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    var numericDetails: some View {
        Group {
            if let coinDetail = viewModel.coinDetail {
                HStack(alignment: .top, spacing: 20) {
                    VStack(spacing: 20) {
                        detailWith(title: "Market Cap", description: coinDetail.marketCap)
                        detailWith(title: "Price Change 24h", description: coinDetail.priceChange24H)
                    }
                    VStack(spacing: 20) {
                        detailWith(title: "Highest Price 24h", description: coinDetail.high24H)
                        detailWith(title: "Lowest Price 24h", description: coinDetail.low24H)
                    }
                }
                
                detailWith(title: "Total Volume", description: coinDetail.totalVolume)
            }
        }
    }
    
    var networkErrorScrollView: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Sorry for the inconvenience, but we can't reach the servers at the moment")
                    .robotoFont(size: 16)
                    .multilineTextAlignment(.center)
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
            viewModel.fetchDetail()
            viewModel.fetchGraph()
        }
    }
    
    func detailWith(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .robotoFont(size: 12, weight: .italic)
                .foregroundStyle(Color(.textSecondary))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(description)
                .robotoFont(size: 16, weight: .bold)
                .foregroundStyle(Color(.textPrimary))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .cardViewStyle(horizontalInset: 10, verticalInset: 5)
    }
    
    var detailViewForGraph: some View {
        Group {
            if let priceHistory = viewModel.priceHistory {
                VStack(spacing: 5) {
                    Text("7-Day Price Chart")
                        .robotoFont(size: 12, weight: .italic)
                        .foregroundStyle(Color(.textSecondary))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    graph(priceHistory)
                }
                .cardViewStyle(horizontalInset: 10, verticalInset: 5)
            } else {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.background)
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .cardViewStyle(horizontalInset: 10, verticalInset: 5)
                    ProgressView()
                }
            }
        }
    }
    
    func graph(_ priceHistory: PriceHistory) -> some View {
        Chart {
            ForEach(0..<priceHistory.extractedPrices.count, id: \.self) { index in
                LineMark(
                    x: .value("Date", priceHistory.dates[index]),
                    y: .value("Price", priceHistory.extractedPrices[index])
                )
                .foregroundStyle(priceHistory.color)
            }
        }
        .chartYScale(domain: (priceHistory.minPrice)...(priceHistory.maxPrice))
        .chartYAxis {
            AxisMarks(values: priceHistory.yAxisValues) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let value = value.as(Double.self) {
                        Text(value.formattedAsShortCurrency())
                            .robotoFont(size: 12, weight: .light)
                            .foregroundStyle(Color(.textSecondary))
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: priceHistory.lastSevenDays) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let value = value.as(Date.self) {
                        Text(value.toStringWith(format: "EEE"))
                            .robotoFont(size: 10, weight: .light)
                            .foregroundStyle(Color(.textSecondary))
                    }
                }
                
            }
        }
        .frame(height: 160)
    }
}

#Preview {
    CoinDetailView(viewModel: CoinDetailView.ViewModel(coinService: MockCoinNetworkService(), coinId: ""))
        .environmentObject(Coordinator())
}
