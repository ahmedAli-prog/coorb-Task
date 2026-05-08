//
//  ExplorerUseCase.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation

class ExplorerUseCase: ExplorerUseCaseProtocol {

    private let searchRepo: ExplorerRepositoryProtocol

    init(searchRepo: ExplorerRepositoryProtocol) {
        self.searchRepo = searchRepo
    }

    // MARK: - Methods
    func cached() -> [WorldCountry] {
        let countryList = searchRepo.fetchCachedCountries()
        return countryList.map { countryModelDTO($0) }
    }

    func deleteCachedCountry(_ country: WorldCountry) {
        searchRepo.deleteCashedCountry(countryEntityDTO(country))
    }

    func search(for country: String) async throws -> WorldCountry? {
        do {
            let country = try await searchRepo.fetchCountries(for: country)
            return countryModelDTO(country)
        } catch {
            throw error
        }
    }

    private func countryModelDTO(_ country: CountryEntity?) -> WorldCountry {
        guard let country = country else {
            return WorldCountry(name: nil, capital: nil, flag: nil, currencyCode: nil, currencyName: nil, currencySymbol: nil)
        }

        return WorldCountry(
            name: country.countryName,
            capital: country.capitalCity,
            flag: country.flags.png,
            currencyCode: country.firstCurrency?.code,
            currencyName: country.firstCurrency?.info.name,
            currencySymbol: country.firstCurrency?.info.symbol
        )
    }

    private func countryEntityDTO(_ country: WorldCountry) -> CountryEntity {
        let currencyCode = country.currencyCode ?? ""
        let currencyInfo = CurrencyInfo(name: country.currencyName, symbol: country.currencySymbol)

        return CountryEntity(
            name: CountryName(common: country.name ?? "", official: country.name ?? ""),
            capital: country.capital != nil ? [country.capital!] : nil,
            flags: Flags(png: country.flag ?? "", svg: nil),
            currencies: currencyCode.isEmpty ? nil : [currencyCode: currencyInfo]
        )
    }
}
