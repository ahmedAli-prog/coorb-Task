//
//  DetailView.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import SwiftUI
import Kingfisher

struct DetailView: View {

    @ObservedObject private var viewModel: DetailViewModel
    @SwiftUI.Environment(\.presentationMode) private var presentationMode

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }
}

// MARK: - View Components
private extension DetailView {

    var backgroundView: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.2, blue: 0.45),
                Color(red: 0.15, green: 0.25, blue: 0.5),
                Color(red: 0.2, green: 0.3, blue: 0.55)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                Text("Back")
                    .font(.system(size: 16))
            }
            .foregroundColor(.white)
        }
    }

    var contentView: some View {
        ScrollView {
            VStack(spacing: 0) {
                flagSection
                infoSection
            }
        }
    }

    var flagSection: some View {
        ZStack(alignment: .bottom) {
            // Flag Image
            KFImage(URL(string: viewModel.flag ?? ""))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        )
                }
                .resizable()
                .scaledToFill()
                .frame(height: Constants.UI.detailsFlagHeight)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.black.opacity(0.3)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Country Name Overlay
            VStack(spacing: 4) {
                Text(viewModel.name ?? "Unknown Country")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
            }
            .padding(.bottom, 20)
        }
    }

    var infoSection: some View {
        VStack(spacing: 20) {
            // Capital Card
            if let capital = viewModel.capital, !capital.isEmpty {
                InfoCard(
                    icon: "building.2.fill",
                    title: "Capital City",
                    value: capital,
                    iconColor: .orange
                )
            }

            // Currency Card
            if viewModel.currencyName != nil || viewModel.code != nil {
                CurrencyCard(
                    code: viewModel.code,
                    name: viewModel.currencyName,
                    symbol: viewModel.symbol
                )
            }

            Spacer(minLength: 50)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.08))
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// MARK: - Info Card Component
struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)

                Text(value)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(Color.white.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Currency Card Component
struct CurrencyCard: View {
    let code: String?
    let name: String?
    let symbol: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: "banknote.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.green)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Currency")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                        .textCase(.uppercase)

                    Text(name ?? "Unknown")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }

                Spacer()
            }

            HStack(spacing: 12) {
                if let code = code, !code.isEmpty {
                    CurrencyBadge(label: "Code", value: code)
                }

                if let symbol = symbol, !symbol.isEmpty {
                    CurrencyBadge(label: "Symbol", value: symbol)
                }

                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(Color.white.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Currency Badge Component
struct CurrencyBadge: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .textCase(.uppercase)

            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.1))
        )
    }
}
