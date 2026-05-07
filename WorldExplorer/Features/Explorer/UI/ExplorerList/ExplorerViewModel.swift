//
//  ExplorerViewModel.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation
import CoreData

class ExplorerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var searchResults: [WorldCountry] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Stored Properties
    private let useCase: ExplorerUseCaseProtocol
    private let locationManager: LocationManagerProtocol
    
    // MARK: - Init
    init(useCase: ExplorerUseCaseProtocol,
         locationManager: LocationManagerProtocol) {
        self.useCase = useCase
        self.locationManager = locationManager
        
        didLoad()
    }
    
    // MARK: - Methods
    private func didLoad() {
        
        checkCachedData()
        getLoaction(searchResults.isEmpty)
    }
    
    private func getLoaction(_ isEnabled: Bool) {
        
        guard isEnabled else { return }
        
        isLoading = true
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    private func checkCachedData() {
        
        isLoading = true
        searchResults = useCase.cached()
        isLoading = false
    }
    
    private func validEntry(query: String) -> Bool {
        let trimmedQuery = query.trimmingCharacters(in: .whitespaces)

        if trimmedQuery.isEmpty {
            showError = true
            errorMessage = ExplorerError.emptySearchField.message
            return false
        }

        if searchResults.count >= Constants.CountryList.maxCountries {
            showError = true
            errorMessage = ExplorerError.fullList.message
            return false
        }

        if searchResults.contains(where: { $0.name?.lowercased() == trimmedQuery.lowercased() }) {
            showError = true
            errorMessage = ExplorerError.duplicate.message
            return false
        }

        return true
    }
    
    @MainActor
    func search(with country: String) async {
        
        guard validEntry(query: country) else { return }
        
        isLoading = true
        
        do {
            guard let country = try await useCase.search(for: country) else {
                isLoading = false
                showError = true
                errorMessage = ExplorerError.wrongName(country).message
                return
            }
            
            searchResults.append(country)
            isLoading = false
            
        } catch {
            isLoading = false
            showError = true
            errorMessage = ExplorerError.other(error.localizedDescription).message
        }
    }
    
    func removeCountry(at offsets: IndexSet) {
        
        guard let index = offsets.first else { return }
        useCase.deleteCachedCountry(searchResults[index])
        searchResults.remove(atOffsets: offsets)
    }
}

//MARK: - LocationManagerDelegate
extension ExplorerViewModel: LocationManagerDelegate {
    func didGetLocation(country: String) {
        Task {
            await search(with: country)
        }
    }
}
