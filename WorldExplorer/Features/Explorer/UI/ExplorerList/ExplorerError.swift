//
//  ExplorerError.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation

/// Represents possible errors that can occur in the country list feature
enum ExplorerError: Error, Equatable {

    case emptySearchField
    case fullList
    case duplicate
    case wrongName(String)
    case networkError
    case other(String)

    /// User-friendly error message
    var message: String {
        switch self {
        case .emptySearchField:
            return "Please enter a country name to search"
        case .fullList:
            return "You've reached the maximum of \(Constants.CountryList.maxCountries) countries. Please remove one to add another."
        case .duplicate:
            return "This country is already in your list. Try adding a different one."
        case let .wrongName(value):
            return "No country found matching \"\(value)\". Please check the spelling."
        case .networkError:
            return "Unable to connect. Please check your internet connection and try again."
        case let .other(value):
            return value
        }
    }

    /// Icon name for the error (SF Symbols)
    var iconName: String {
        switch self {
        case .emptySearchField:
            return "text.cursor"
        case .fullList:
            return "exclamationmark.circle"
        case .duplicate:
            return "doc.on.doc"
        case .wrongName:
            return "magnifyingglass"
        case .networkError:
            return "wifi.slash"
        case .other:
            return "exclamationmark.triangle"
        }
    }

    static func == (lhs: ExplorerError, rhs: ExplorerError) -> Bool {
        switch (lhs, rhs) {
        case (.emptySearchField, .emptySearchField),
             (.fullList, .fullList),
             (.duplicate, .duplicate),
             (.networkError, .networkError):
            return true
        case let (.wrongName(lhsValue), .wrongName(rhsValue)):
            return lhsValue == rhsValue
        case let (.other(lhsValue), .other(rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}
