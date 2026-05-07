//
//  APIConfig.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//


enum APIConfig {
    
    case fetchCountry
    
    var path: String {
        switch self {
        case .fetchCountry:
            return Endpoints.searchCountry.rawValue
        }
    }
}
