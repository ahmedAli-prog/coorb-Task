//
//  DetailViewModelTests.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

import XCTest
@testable import WorldExplorer

final class DetailViewModelTests: XCTestCase {

    // MARK: - Basic Loading Tests

    func test_loadValues_withCompleteData() {
        // Given
        let country = TestData.country

        // When
        let viewModel = DetailViewModel(country: country)

        // Then
        XCTAssertEqual(viewModel.name, country.name)
        XCTAssertEqual(viewModel.capital, country.capital)
        XCTAssertEqual(viewModel.flag, country.flag)
        XCTAssertEqual(viewModel.code, country.currencyCode)
        XCTAssertEqual(viewModel.currencyName, country.currencyName)
        XCTAssertEqual(viewModel.symbol, country.currencySymbol)
    }

    func test_loadValues_withMissingData() {
        // Given
        let country = TestData.countryWithMissingData

        // When
        let viewModel = DetailViewModel(country: country)

        // Then
        XCTAssertEqual(viewModel.name, "Test Country")
        XCTAssertNil(viewModel.capital)
        XCTAssertNil(viewModel.flag)
        XCTAssertNil(viewModel.code)
        XCTAssertNil(viewModel.currencyName)
        XCTAssertNil(viewModel.symbol)
    }

    func test_loadValues_USACountry() {
        // Given
        let country = TestData.countryUSA

        // When
        let viewModel = DetailViewModel(country: country)

        // Then
        XCTAssertEqual(viewModel.name, "United States of America")
        XCTAssertEqual(viewModel.capital, "Washington, D.C.")
        XCTAssertEqual(viewModel.code, "USD")
        XCTAssertEqual(viewModel.symbol, "$")
    }

    func test_loadValues_UKCountry() {
        // Given
        let country = TestData.countryUK

        // When
        let viewModel = DetailViewModel(country: country)

        // Then
        XCTAssertEqual(viewModel.name, "United Kingdom")
        XCTAssertEqual(viewModel.capital, "London")
        XCTAssertEqual(viewModel.code, "GBP")
    }

    func test_loadValues_flagURL() {
        // Given
        let country = TestData.country

        // When
        let viewModel = DetailViewModel(country: country)

        // Then
        XCTAssertNotNil(viewModel.flag)
        XCTAssertTrue(viewModel.flag?.contains("https://") ?? false)
    }
}
