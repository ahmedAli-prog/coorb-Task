//
//  ExplorerUseCaseProtocol.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

protocol ExplorerUseCaseProtocol {
    
    func cached() -> [WorldCountry]
    func deleteCachedCountry(_ country: WorldCountry)
    func search(for country: String) async throws -> WorldCountry?
}
