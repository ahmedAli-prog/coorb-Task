//
//  TestData.swift
//  WorldExplorerTests
//
//  Created by ahmed ali on 7/5/26.
//

@testable import WorldExplorer

/// Provides mock data for unit testing
enum TestData {

    // MARK: - Country Models
    static let country = WorldCountry(
        name: "Egypt",
        capital: "Cairo",
        flag: "https://flagcdn.com/w320/eg.png",
        currencyCode: "EGP",
        currencyName: "Egyptian Pound",
        currencySymbol: "£"
    )

    static let countryUSA = WorldCountry(
        name: "United States of America",
        capital: "Washington, D.C.",
        flag: "https://flagcdn.com/w320/us.png",
        currencyCode: "USD",
        currencyName: "United States Dollar",
        currencySymbol: "$"
    )

    static let countryUK = WorldCountry(
        name: "United Kingdom",
        capital: "London",
        flag: "https://flagcdn.com/w320/gb.png",
        currencyCode: "GBP",
        currencyName: "British Pound Sterling",
        currencySymbol: "£"
    )

    static let countryGermany = WorldCountry(
        name: "Germany",
        capital: "Berlin",
        flag: "https://flagcdn.com/w320/de.png",
        currencyCode: "EUR",
        currencyName: "Euro",
        currencySymbol: "€"
    )

    static let countryJapan = WorldCountry(
        name: "Japan",
        capital: "Tokyo",
        flag: "https://flagcdn.com/w320/jp.png",
        currencyCode: "JPY",
        currencyName: "Japanese Yen",
        currencySymbol: "¥"
    )

    static let countryWithMissingData = WorldCountry(
        name: "Test Country",
        capital: nil,
        flag: nil,
        currencyCode: nil,
        currencyName: nil,
        currencySymbol: nil
    )

    // MARK: - Country Lists
    static let fiveCountries: [WorldCountry] = [
        country,
        countryUSA,
        countryUK,
        countryGermany,
        countryJapan
    ]

    static let threeCountries: [WorldCountry] = [
        country,
        countryUSA,
        countryUK
    ]

    // MARK: - Country Entities (API v3.1 format)
    static let countryEntity = CountryEntity(
        name: CountryName(common: "Egypt", official: "Arab Republic of Egypt"),
        capital: ["Cairo"],
        flags: Flags(png: "https://flagcdn.com/w320/eg.png", svg: nil),
        currencies: ["EGP": CurrencyInfo(name: "Egyptian Pound", symbol: "£")]
    )

    static let countryEntityNoCurrency = CountryEntity(
        name: CountryName(common: "Antarctica", official: "Antarctica"),
        capital: nil,
        flags: Flags(png: "https://flagcdn.com/w320/aq.png", svg: nil),
        currencies: nil
    )
}
