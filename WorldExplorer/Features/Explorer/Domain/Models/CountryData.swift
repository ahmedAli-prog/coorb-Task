//
//  CountryEntity.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

// MARK: - CountryEntity (API v3.1 format)
struct CountryEntity: Codable {
    let name: CountryName
    let capital: [String]?
    let flags: Flags
    let currencies: [String: CurrencyInfo]?

    /// Computed property to get country name as string
    var countryName: String {
        name.common
    }

    /// Computed property to get first capital
    var capitalCity: String? {
        capital?.first
    }

    /// Computed property to get first currency
    var firstCurrency: (code: String, info: CurrencyInfo)? {
        guard let currencies = currencies, let first = currencies.first else { return nil }
        return (first.key, first.value)
    }
}

// MARK: - CountryName
struct CountryName: Codable {
    let common: String
    let official: String
}

// MARK: - CurrencyInfo
struct CurrencyInfo: Codable {
    let name: String?
    let symbol: String?
}

// MARK: - Currency (for backward compatibility in tests)
struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String
}

// MARK: - Flags
struct Flags: Codable {
    let png: String
    let svg: String?
}
