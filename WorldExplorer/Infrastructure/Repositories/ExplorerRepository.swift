//
//  ExplorerRepository.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import CoreData

class ExplorerRepository: ExplorerRepositoryProtocol {

    // MARK: - Properties
    let client: NetworkClient
    private var viewContext = DataStore.shared.viewContext

    // MARK: - Init
    init() {
        client = NetworkClient(baseUrl: Environment.baseUrl)
    }

    // MARK: - Methods
    func fetchCachedCountries() -> [CountryEntity] {
        fetchCountries().map { countryDBToEntity($0) }
    }

    func deleteCashedCountry(_ country: CountryEntity) {
        fetchAndDeleteCountry(country)
    }

    func fetchCountries(for country: String) async throws -> CountryEntity? {
        do {
            let countryList: [CountryEntity] = try await client.performRequest(path: APIConfig.fetchCountry.path)

            // Use countryName computed property for comparison
            let foundCountry = countryList.first(where: { $0.countryName.lowercased() == country.lowercased() })

            saveCountry(foundCountry)
            return foundCountry
        } catch {
            throw error
        }
    }
}

// MARK: - Core Data
extension ExplorerRepository {

    private func saveCountry(_ country: CountryEntity?) {
        guard let country else { return }

        _ = countryEntityToDB(country)

        do {
            try viewContext.save()
        } catch {
            print("Error saving country: \(error)")
        }
    }

    private func fetchCountries() -> [CountryDB] {
        let fetchRequest: NSFetchRequest<CountryDB> = CountryDB.fetchRequest()

        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }

    func fetchAndDeleteCountry(_ country: CountryEntity) {
        let fetchRequest: NSFetchRequest<CountryDB> = CountryDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", country.countryName)

        do {
            let countryDB = try viewContext.fetch(fetchRequest)

            if let countryToDelete = countryDB.first {
                viewContext.delete(countryToDelete)
                try viewContext.save()
            }
        } catch {
            print("Failed to fetch or delete: \(error)")
        }
    }

    private func countryEntityToDB(_ countryEntity: CountryEntity) -> CountryDB {
        let countryDB = CountryDB(context: viewContext)
        countryDB.name = countryEntity.countryName
        countryDB.capital = countryEntity.capitalCity
        countryDB.flag = countryEntity.flags.png

        if let currency = countryEntity.firstCurrency {
            countryDB.currencyCode = currency.code
            countryDB.currencyName = currency.info.name
            countryDB.currencySymbol = currency.info.symbol
        }

        return countryDB
    }

    private func countryDBToEntity(_ countryDB: CountryDB) -> CountryEntity {
        let currencyCode = countryDB.currencyCode ?? ""
        let currencyInfo = CurrencyInfo(
            name: countryDB.currencyName,
            symbol: countryDB.currencySymbol
        )

        return CountryEntity(
            name: CountryName(common: countryDB.name ?? "", official: countryDB.name ?? ""),
            capital: countryDB.capital != nil ? [countryDB.capital!] : nil,
            flags: Flags(png: countryDB.flag ?? "", svg: nil),
            currencies: currencyCode.isEmpty ? nil : [currencyCode: currencyInfo]
        )
    }
}
