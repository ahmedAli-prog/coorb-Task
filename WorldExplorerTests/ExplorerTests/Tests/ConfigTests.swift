//
//  ConfigTests.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

import XCTest
@testable import WorldExplorer

final class ConfigTests: XCTestCase {

    // MARK: - Country List Constants

    func test_maxCountries_isReasonableValue() {
        // The max should be between 1 and 10 for a reasonable UX
        XCTAssertGreaterThanOrEqual(Constants.CountryList.maxCountries, 1)
        XCTAssertLessThanOrEqual(Constants.CountryList.maxCountries, 10)
    }

    func test_maxCountries_isFive() {
        XCTAssertEqual(Constants.CountryList.maxCountries, 5)
    }

    func test_defaultCountry_isNotEmpty() {
        XCTAssertFalse(Constants.CountryList.defaultCountry.isEmpty)
    }

    func test_defaultCountry_isEgypt() {
        XCTAssertEqual(Constants.CountryList.defaultCountry, "Egypt")
    }

    // MARK: - UI Constants

    func test_cornerRadius_isPositive() {
        XCTAssertGreaterThan(Constants.UI.cornerRadius, 0)
    }

    func test_shadowRadius_isPositive() {
        XCTAssertGreaterThan(Constants.UI.shadowRadius, 0)
    }

    func test_flagImageSize_isPositive() {
        XCTAssertGreaterThan(Constants.UI.flagImageSize, 0)
    }

    func test_detailsFlagHeight_isPositive() {
        XCTAssertGreaterThan(Constants.UI.detailsFlagHeight, 0)
    }

    func test_cardPadding_isPositive() {
        XCTAssertGreaterThan(Constants.UI.cardPadding, 0)
    }

    func test_listRowSpacing_isPositive() {
        XCTAssertGreaterThan(Constants.UI.listRowSpacing, 0)
    }

    // MARK: - Animation Constants

    func test_defaultDuration_isPositive() {
        XCTAssertGreaterThan(Constants.Animation.defaultDuration, 0)
    }

    func test_defaultDuration_isReasonable() {
        // Animation should be less than 1 second for good UX
        XCTAssertLessThanOrEqual(Constants.Animation.defaultDuration, 1.0)
    }
}
