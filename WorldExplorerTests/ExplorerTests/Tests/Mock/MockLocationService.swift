//
//  MockLocationService.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

@testable import WorldExplorer

/// Mock implementation of LocationManagerProtocol for unit testing
class MockLocationService: LocationManagerProtocol {

    // MARK: - Tracking Properties
    var locationRequested: Bool = false
    var requestCount: Int = 0

    // MARK: - Configuration Properties
    var countryToReturn: String
    var shouldSimulateLocationDenied: Bool
    var shouldCallDelegate: Bool

    // MARK: - Protocol Properties
    weak var delegate: LocationManagerDelegate?

    // MARK: - Initialization
    init(
        countryToReturn: String = Constants.CountryList.defaultCountry,
        shouldSimulateLocationDenied: Bool = false,
        shouldCallDelegate: Bool = true
    ) {
        self.countryToReturn = countryToReturn
        self.shouldSimulateLocationDenied = shouldSimulateLocationDenied
        self.shouldCallDelegate = shouldCallDelegate
    }

    // MARK: - Protocol Methods
    func requestLocation() {
        locationRequested = true
        requestCount += 1

        guard shouldCallDelegate else { return }

        if shouldSimulateLocationDenied {
            delegate?.didGetLocation(country: Constants.CountryList.defaultCountry)
        } else {
            delegate?.didGetLocation(country: countryToReturn)
        }
    }

    // MARK: - Test Helpers

    /// Resets all tracking properties
    func reset() {
        locationRequested = false
        requestCount = 0
    }

    /// Creates a location manager that returns a specific country
    static func returning(country: String) -> MockLocationService {
        MockLocationService(countryToReturn: country)
    }

    /// Creates a location manager that simulates denied permission
    static func denied() -> MockLocationService {
        MockLocationService(shouldSimulateLocationDenied: true)
    }

    /// Creates a location manager that doesn't call delegate
    static func silent() -> MockLocationService {
        MockLocationService(shouldCallDelegate: false)
    }
}
