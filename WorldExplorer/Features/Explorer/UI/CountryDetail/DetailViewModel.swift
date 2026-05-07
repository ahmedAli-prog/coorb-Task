//
//  DetailViewModel.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation

class DetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var name: String?
    @Published var capital: String?
    @Published var flag: String?
    @Published var code: String?
    @Published var currencyName: String?
    @Published var symbol: String?
    
    // MARK: - Stored Properties
    private let country: WorldCountry
    
    // MARK: - Init
    init(country: WorldCountry) {
        self.country = country
        loadValues()
    }
    
    //MARK: -
    private func loadValues() {
        name = country.name
        capital = country.capital
        flag = country.flag
        code = country.currencyCode
        currencyName = country.currencyName
        symbol = country.currencySymbol
    }
}
