//
//  ExplorerView.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import SwiftUI
import Kingfisher

struct ExplorerView: View {

    @ObservedObject private var viewModel: ExplorerViewModel
    @State private var searchText: String = ""

    init(viewModel: ExplorerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient

                VStack(spacing: 0) {
                    headerSection
                    searchSection
                    countryListSection
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(viewModel.errorMessage ?? "An error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - View Components
private extension ExplorerView {

    var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.2, blue: 0.45),
                Color(red: 0.15, green: 0.25, blue: 0.5)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Explore")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)

                    Text("Countries")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()

                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            countryCountBadge
        }
    }

    var countryCountBadge: some View {
        HStack {
            Text("\(viewModel.searchResults.count)/\(Constants.CountryList.maxCountries)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(viewModel.searchResults.count >= Constants.CountryList.maxCountries
                              ? Color.red.opacity(0.8)
                              : Color.green.opacity(0.6))
                )

            Text("countries added")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    var searchSection: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search for a country...", text: $searchText)
                    .foregroundColor(.primary)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit { search() }

                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(14)
            .background(Color.white)
            .cornerRadius(Constants.UI.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)

            Button(action: { search() }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 3)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    var countryListSection: some View {
        ZStack {
            if viewModel.searchResults.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                countryList
            }

            if viewModel.isLoading {
                loadingOverlay
            }
        }
    }

    var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "globe.desk")
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.3))

            Text("No countries yet")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))

            Text("Search and add up to 5 countries\nto build your collection")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var countryList: some View {
        ScrollView {
            LazyVStack(spacing: Constants.UI.listRowSpacing) {
                ForEach(Array(viewModel.searchResults.enumerated()), id: \.element.name) { index, country in
                    NavigationLink(destination: DetailRouter.createModule(with: country)) {
                        CountryRowView(country: country, index: index)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .contextMenu {
                        Button(role: .destructive) {
                            withAnimation(.easeOut(duration: Constants.Animation.defaultDuration)) {
                                viewModel.removeCountry(at: IndexSet(integer: index))
                            }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.1))
                .ignoresSafeArea(edges: .bottom)
        )
    }

    var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)

                Text("Loading...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.1, green: 0.2, blue: 0.4).opacity(0.95))
            )
            .shadow(color: .black.opacity(0.3), radius: 20)
        }
    }
}

// MARK: - Methods
extension ExplorerView {

    private func search() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        Task {
            await viewModel.search(with: searchText)
            searchText = ""
        }
    }
}

// MARK: - Country Row View
struct CountryRowView: View {
    let country: WorldCountry
    let index: Int

    var body: some View {
        HStack(spacing: 16) {
            // Flag Image
            KFImage(URL(string: country.flag ?? ""))
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                }
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)

            // Country Info
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name ?? "Unknown")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)

                HStack(spacing: 8) {
                    if let capital = country.capital, !capital.isEmpty {
                        Label(capital, systemImage: "building.2.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    if let currency = country.currencyCode {
                        Text(currency)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(Color.white.opacity(0.2)))
                    }
                }
            }

            Spacer()

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding(Constants.UI.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.08)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}
