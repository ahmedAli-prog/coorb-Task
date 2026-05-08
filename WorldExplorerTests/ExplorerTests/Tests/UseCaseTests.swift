//
//  UseCaseTests.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

import XCTest
@testable import WorldExplorer

final class UseCaseTests: XCTestCase {

    // MARK: - Model Conversion Tests

    func test_countryModel_hasAllProperties() {
        // Given
        let model = TestData.country

        // Then
        XCTAssertNotNil(model.name)
        XCTAssertNotNil(model.capital)
        XCTAssertNotNil(model.flag)
        XCTAssertNotNil(model.currencyCode)
        XCTAssertNotNil(model.currencyName)
        XCTAssertNotNil(model.currencySymbol)
    }

    func test_countryModel_withMissingData_handlesNils() {
        // Given
        let model = TestData.countryWithMissingData

        // Then
        XCTAssertNotNil(model.name)
        XCTAssertNil(model.capital)
        XCTAssertNil(model.flag)
        XCTAssertNil(model.currencyCode)
    }

    // MARK: - Country Entity Tests (API v3.1 format)

    func test_countryEntity_decodable() {
        // Given - API v3.1 format
        let json = """
        {
            "name": {"common": "Egypt", "official": "Arab Republic of Egypt"},
            "capital": ["Cairo"],
            "flags": {"png": "https://example.com/flag.png", "svg": "https://example.com/flag.svg"},
            "currencies": {"EGP": {"name": "Egyptian pound", "symbol": "£"}}
        }
        """.data(using: .utf8)!

        // When
        let entity = try? JSONDecoder().decode(CountryEntity.self, from: json)

        // Then
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.countryName, "Egypt")
        XCTAssertEqual(entity?.capitalCity, "Cairo")
        XCTAssertEqual(entity?.flags.png, "https://example.com/flag.png")
        XCTAssertEqual(entity?.firstCurrency?.code, "EGP")
    }

    func test_countryEntity_withOptionalCapital() {
        // Given
        let json = """
        {
            "name": {"common": "Antarctica", "official": "Antarctica"},
            "flags": {"png": "https://example.com/flag.png"}
        }
        """.data(using: .utf8)!

        // When
        let entity = try? JSONDecoder().decode(CountryEntity.self, from: json)

        // Then
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.countryName, "Antarctica")
        XCTAssertNil(entity?.capitalCity)
        XCTAssertNil(entity?.currencies)
    }

    func test_countryEntity_withMultipleCurrencies() {
        // Given - API v3.1 format with multiple currencies
        let json = """
        {
            "name": {"common": "Test Country", "official": "Test Country"},
            "capital": ["Test Capital"],
            "flags": {"png": "https://example.com/flag.png"},
            "currencies": {
                "USD": {"name": "US Dollar", "symbol": "$"},
                "EUR": {"name": "Euro", "symbol": "€"}
            }
        }
        """.data(using: .utf8)!

        // When
        let entity = try? JSONDecoder().decode(CountryEntity.self, from: json)

        // Then
        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.currencies?.count, 2)
        XCTAssertNotNil(entity?.firstCurrency)
    }

    // MARK: - Currency Tests

    func test_currency_decodable() {
        // Given
        let json = """
        {"code": "USD", "name": "US Dollar", "symbol": "$"}
        """.data(using: .utf8)!

        // When
        let currency = try? JSONDecoder().decode(Currency.self, from: json)

        // Then
        XCTAssertNotNil(currency)
        XCTAssertEqual(currency?.code, "USD")
        XCTAssertEqual(currency?.name, "US Dollar")
        XCTAssertEqual(currency?.symbol, "$")
    }

    // MARK: - CurrencyInfo Tests

    func test_currencyInfo_decodable() {
        // Given
        let json = """
        {"name": "US Dollar", "symbol": "$"}
        """.data(using: .utf8)!

        // When
        let currencyInfo = try? JSONDecoder().decode(CurrencyInfo.self, from: json)

        // Then
        XCTAssertNotNil(currencyInfo)
        XCTAssertEqual(currencyInfo?.name, "US Dollar")
        XCTAssertEqual(currencyInfo?.symbol, "$")
    }

    // MARK: - Flags Tests

    func test_flags_decodable() {
        // Given
        let json = """
        {"png": "https://example.com/flag.png"}
        """.data(using: .utf8)!

        // When
        let flags = try? JSONDecoder().decode(Flags.self, from: json)

        // Then
        XCTAssertNotNil(flags)
        XCTAssertEqual(flags?.png, "https://example.com/flag.png")
    }

    // MARK: - CountryName Tests

    func test_countryName_decodable() {
        // Given
        let json = """
        {"common": "Egypt", "official": "Arab Republic of Egypt"}
        """.data(using: .utf8)!

        // When
        let countryName = try? JSONDecoder().decode(CountryName.self, from: json)

        // Then
        XCTAssertNotNil(countryName)
        XCTAssertEqual(countryName?.common, "Egypt")
        XCTAssertEqual(countryName?.official, "Arab Republic of Egypt")
    }
}
