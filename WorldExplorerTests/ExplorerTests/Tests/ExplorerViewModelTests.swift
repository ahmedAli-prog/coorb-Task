//
//  ExplorerViewModelTests.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

import XCTest
@testable import WorldExplorer

final class ExplorerViewModelTests: XCTestCase {

    // MARK: - Properties
    private var useCase: MockUseCase!
    private var locationManager: MockLocationService!
    private var viewModel: ExplorerViewModel!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        useCase = MockUseCase(isEmptyCache: true)
        locationManager = MockLocationService()
    }

    override func tearDown() {
        useCase = nil
        locationManager = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Cache Tests

    func test_checkCachedData_success() {
        // Given & When
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)

        // Then
        XCTAssertTrue(useCase.countryCached, "Cache should be checked on initialization")
    }

    func test_checkCachedData_loadsExistingCountries() {
        // Given
        useCase = MockUseCase(isEmptyCache: false)

        // When
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)

        // Then
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Should load cached countries")
    }

    // MARK: - Location Tests

    func test_getLocation_requestedWhenCacheEmpty() {
        // Given & When
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)

        // Then
        XCTAssertTrue(locationManager.locationRequested, "Location should be requested when cache is empty")
    }

    func test_getLocation_notRequestedWhenCacheNotEmpty() {
        // Given
        useCase = MockUseCase(isEmptyCache: false)

        // When
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)

        // Then
        XCTAssertFalse(locationManager.locationRequested, "Location should NOT be requested when cache has data")
    }

    func test_locationDelegate_addsCountryOnSuccess() async {
        // Given
        useCase = MockUseCase(isEmptyCache: true, isValidCountry: true)
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = []

        // When
        viewModel.didGetLocation(country: "Egypt")

        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000)

        // Then
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Country should be added after location callback")
    }

    // MARK: - Remove Country Tests

    func test_removeCountry_success() {
        // Given
        useCase = MockUseCase(isEmptyCache: false)
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = [TestData.country]

        // When
        viewModel.removeCountry(at: IndexSet(integer: 0))

        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty, "Country should be removed from list")
        XCTAssertTrue(useCase.countryCachedDeleted, "Country should be deleted from cache")
    }

    func test_removeCountry_removesCorrectCountry() {
        // Given
        useCase = MockUseCase(isEmptyCache: false)
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = TestData.threeCountries

        // When - Remove middle country (USA)
        viewModel.removeCountry(at: IndexSet(integer: 1))

        // Then
        XCTAssertEqual(viewModel.searchResults.count, 2)
        XCTAssertEqual(viewModel.searchResults[0].name, "Egypt")
        XCTAssertEqual(viewModel.searchResults[1].name, "United Kingdom")
    }

    func test_removeCountry_allowsAddingNewCountryAfterRemoval() async {
        // Given
        useCase = MockUseCase(isEmptyCache: false, isValidCountry: true)
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = TestData.fiveCountries

        // When - Remove one and add new
        viewModel.removeCountry(at: IndexSet(integer: 0))
        await viewModel.search(with: "France")

        // Then
        XCTAssertEqual(viewModel.searchResults.count, 5, "Should allow adding after removal")
    }

    // MARK: - Validation Tests

    func test_validEntry_emptyString() async {
        // Given
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = []

        // When
        await viewModel.search(with: "")

        // Then
        XCTAssertTrue(viewModel.showError, "Should show error")
        XCTAssertEqual(viewModel.errorMessage, ExplorerError.emptySearchField.message)
    }

    func test_validEntry_whitespaceOnly() async {
        // Given
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = []

        // When
        await viewModel.search(with: "   ")

        // Then
        XCTAssertTrue(viewModel.showError, "Should show error for whitespace-only input")
        XCTAssertEqual(viewModel.errorMessage, ExplorerError.emptySearchField.message)
    }

    func test_validEntry_fullList() async {
        // Given
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = TestData.fiveCountries

        // When
        await viewModel.search(with: "France")

        // Then
        XCTAssertTrue(viewModel.showError, "Should show error when list is full")
        XCTAssertEqual(viewModel.errorMessage, ExplorerError.fullList.message)
    }

    func test_validEntry_duplicate_exactMatch() async {
        // Given
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = [TestData.country]

        // When
        await viewModel.search(with: "Egypt")

        // Then
        XCTAssertTrue(viewModel.showError, "Should show error for duplicate")
        XCTAssertEqual(viewModel.errorMessage, ExplorerError.duplicate.message)
    }

    func test_validEntry_duplicate_caseInsensitive() async {
        // Given
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = [TestData.country]

        // When
        await viewModel.search(with: "EGYPT")

        // Then
        XCTAssertTrue(viewModel.showError, "Should detect duplicate regardless of case")
        XCTAssertEqual(viewModel.errorMessage, ExplorerError.duplicate.message)
    }

    func test_validEntry_duplicate_mixedCase() async {
        // Given
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = [TestData.country]

        // When
        await viewModel.search(with: "eGyPt")

        // Then
        XCTAssertTrue(viewModel.showError, "Should detect duplicate with mixed case")
    }

    // MARK: - Search Tests

    func test_search_wrongName() async {
        // Given - Use silent location manager to prevent auto-search
        useCase = MockUseCase(isEmptyCache: true, isValidCountry: false)
        locationManager = MockLocationService.silent()
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = []

        // When
        await viewModel.search(with: "InvalidCountry")

        // Then
        XCTAssertTrue(viewModel.showError, "Should show error for invalid country")
        XCTAssertEqual(viewModel.errorMessage, ExplorerError.wrongName("InvalidCountry").message)
    }

    func test_search_success() async {
        // Given - Use silent location manager to prevent auto-search
        useCase = MockUseCase(isEmptyCache: true, isValidCountry: true)
        locationManager = MockLocationService.silent()
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = []

        // When
        await viewModel.search(with: "Egypt")

        // Then
        XCTAssertFalse(viewModel.searchResults.isEmpty, "Should add country on success")
        XCTAssertTrue(useCase.searched, "Search should be called on use case")
    }

    func test_search_addsToExistingList() async {
        // Given - Use non-empty cache to prevent location request
        useCase = MockUseCase(isEmptyCache: false, isValidCountry: true)
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        let initialCount = viewModel.searchResults.count

        // When
        await viewModel.search(with: "France")

        // Then
        XCTAssertEqual(viewModel.searchResults.count, initialCount + 1, "Should add to existing list")
    }

    // MARK: - Loading State Tests

    func test_search_setsLoadingState() async {
        // Given - Use silent location manager to prevent auto-search
        useCase = MockUseCase(isEmptyCache: true, isValidCountry: true)
        locationManager = MockLocationService.silent()
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = []

        // Then - After search completes
        await viewModel.search(with: "Egypt")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after search completes")
    }

    // MARK: - Error State Tests

    func test_errorState_showsOnFailure() async {
        // Given - Use silent location manager to prevent auto-search
        useCase = MockUseCase(isEmptyCache: true, isValidCountry: false)
        locationManager = MockLocationService.silent()
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = []

        // When
        await viewModel.search(with: "InvalidCountry")

        // Then
        XCTAssertTrue(viewModel.showError, "Error should be shown on failed search")
        XCTAssertNotNil(viewModel.errorMessage, "Error message should be set")
    }

    // MARK: - Constants Tests

    func test_maxCountries_usesConstant() async {
        // Given
        useCase = MockUseCase(isEmptyCache: true, isValidCountry: true)
        viewModel = ExplorerViewModel(useCase: useCase, locationManager: locationManager)
        viewModel.searchResults = Array(repeating: TestData.country, count: Constants.CountryList.maxCountries)

        // When
        await viewModel.search(with: "France")

        // Then
        XCTAssertEqual(viewModel.searchResults.count, Constants.CountryList.maxCountries,
                      "Should respect max countries constant")
        XCTAssertTrue(viewModel.showError, "Should show error when at max capacity")
    }
}
