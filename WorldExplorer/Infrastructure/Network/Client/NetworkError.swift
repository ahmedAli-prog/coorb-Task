//
//  NetworkError.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation

 enum NetworkError {
    case generalError
    case decodingError(Error)
}


extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .generalError:
            return "Something went wrong, please try again later"
        case let .decodingError(error):
            return "Decoding Error, please check \(error.localizedDescription)"
        }
    }
}
