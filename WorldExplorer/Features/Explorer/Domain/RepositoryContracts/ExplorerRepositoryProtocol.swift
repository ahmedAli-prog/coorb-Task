//
//  ExplorerRepositoryProtocol.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

protocol ExplorerRepositoryProtocol {
    
    func fetchCachedCountries() -> [CountryEntity]
    func deleteCashedCountry(_ country: CountryEntity)
    func fetchCountries(for country: String) async throws -> CountryEntity?
}
