//
//  ExplorerErrorTests.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

import XCTest
@testable import WorldExplorer

final class ExplorerErrorTests: XCTestCase {

    // MARK: - Error Messages Tests

    func test_emptySearchField_message() {
        // Given
        let error = ExplorerError.emptySearchField

        // Then
        XCTAssertEqual(error.message, "Please enter a country name to search")
    }

    func test_fullList_message_containsMaxCount() {
        // Given
        let error = ExplorerError.fullList

        // Then
        XCTAssertTrue(error.message.contains("\(Constants.CountryList.maxCountries)"),
                     "Error message should include max countries count")
    }

    func test_duplicate_message() {
        // Given
        let error = ExplorerError.duplicate

        // Then
        XCTAssertEqual(error.message, "This country is already in your list. Try adding a different one.")
    }

    func test_wrongName_message_containsCountryName() {
        // Given
        let countryName = "Narnia"
        let error = ExplorerError.wrongName(countryName)

        // Then
        XCTAssertTrue(error.message.contains(countryName),
                     "Error message should include the searched country name")
    }

    func test_networkError_message() {
        // Given
        let error = ExplorerError.networkError

        // Then
        XCTAssertTrue(error.message.contains("internet"),
                     "Network error should mention internet connection")
    }

    func test_other_message_returnsCustomValue() {
        // Given
        let customMessage = "Custom error message"
        let error = ExplorerError.other(customMessage)

        // Then
        XCTAssertEqual(error.message, customMessage)
    }

    // MARK: - Error Icon Tests

    func test_emptySearchField_icon() {
        XCTAssertEqual(ExplorerError.emptySearchField.iconName, "text.cursor")
    }

    func test_fullList_icon() {
        XCTAssertEqual(ExplorerError.fullList.iconName, "exclamationmark.circle")
    }

    func test_duplicate_icon() {
        XCTAssertEqual(ExplorerError.duplicate.iconName, "doc.on.doc")
    }

    func test_wrongName_icon() {
        XCTAssertEqual(ExplorerError.wrongName("Test").iconName, "magnifyingglass")
    }

    func test_networkError_icon() {
        XCTAssertEqual(ExplorerError.networkError.iconName, "wifi.slash")
    }

    func test_other_icon() {
        XCTAssertEqual(ExplorerError.other("Test").iconName, "exclamationmark.triangle")
    }

    // MARK: - Equatable Tests

    func test_equatable_sameErrors() {
        XCTAssertEqual(ExplorerError.emptySearchField, ExplorerError.emptySearchField)
        XCTAssertEqual(ExplorerError.fullList, ExplorerError.fullList)
        XCTAssertEqual(ExplorerError.duplicate, ExplorerError.duplicate)
        XCTAssertEqual(ExplorerError.networkError, ExplorerError.networkError)
    }

    func test_equatable_wrongName_sameValue() {
        XCTAssertEqual(ExplorerError.wrongName("Egypt"), ExplorerError.wrongName("Egypt"))
    }

    func test_equatable_wrongName_differentValue() {
        XCTAssertNotEqual(ExplorerError.wrongName("Egypt"), ExplorerError.wrongName("USA"))
    }

    func test_equatable_other_sameValue() {
        XCTAssertEqual(ExplorerError.other("Error"), ExplorerError.other("Error"))
    }

    func test_equatable_other_differentValue() {
        XCTAssertNotEqual(ExplorerError.other("Error1"), ExplorerError.other("Error2"))
    }

    func test_equatable_differentErrors() {
        XCTAssertNotEqual(ExplorerError.emptySearchField, ExplorerError.fullList)
        XCTAssertNotEqual(ExplorerError.duplicate, ExplorerError.networkError)
    }
}
