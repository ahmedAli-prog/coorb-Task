//
//  MockUseCase.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation
@testable import WorldExplorer

/// Mock implementation of ExplorerUseCaseProtocol for unit testing
class MockUseCase: ExplorerUseCaseProtocol {

    // MARK: - Tracking Properties
    var countryCached: Bool = false
    var countryCachedDeleted: Bool = false
    var searched: Bool = false
    var searchedCountryName: String?
    var deletedCountryName: String?

    // MARK: - Configuration Properties
    var isEmptyCache: Bool
    var isValidCountry: Bool
    var shouldThrowError: Bool
    var cachedCountries: [WorldCountry]
    var searchDelay: TimeInterval

    // MARK: - Initialization
    init(
        isEmptyCache: Bool,
        isValidCountry: Bool = false,
        shouldThrowError: Bool = false,
        cachedCountries: [WorldCountry]? = nil,
        searchDelay: TimeInterval = 0
    ) {
        self.isEmptyCache = isEmptyCache
        self.isValidCountry = isValidCountry
        self.shouldThrowError = shouldThrowError
        self.cachedCountries = cachedCountries ?? (isEmptyCache ? [] : [TestData.country])
        self.searchDelay = searchDelay
    }

    // MARK: - Protocol Methods

    func cached() -> [WorldCountry] {
        countryCached = true
        return isEmptyCache ? [] : cachedCountries
    }

    func deleteCachedCountry(_ country: WorldCountry) {
        countryCachedDeleted = true
        deletedCountryName = country.name
    }

    func search(for country: String) async throws -> WorldCountry? {
        searched = true
        searchedCountryName = country

        // Simulate network delay if configured
        if searchDelay > 0 {
            try? await Task.sleep(nanoseconds: UInt64(searchDelay * 1_000_000_000))
        }

        // Throw error if configured
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        }

        return isValidCountry ? TestData.country : nil
    }
}

// MARK: - Test Helpers
extension MockUseCase {

    /// Resets all tracking properties
    func reset() {
        countryCached = false
        countryCachedDeleted = false
        searched = false
        searchedCountryName = nil
        deletedCountryName = nil
    }

    /// Creates a use case configured to return a specific country
    static func withCountry(_ country: WorldCountry) -> MockUseCase {
        let useCase = MockUseCase(isEmptyCache: false, isValidCountry: true)
        useCase.cachedCountries = [country]
        return useCase
    }

    /// Creates a use case configured with multiple cached countries
    static func withCachedCountries(_ countries: [WorldCountry]) -> MockUseCase {
        let useCase = MockUseCase(isEmptyCache: countries.isEmpty, isValidCountry: true)
        useCase.cachedCountries = countries
        return useCase
    }
}
