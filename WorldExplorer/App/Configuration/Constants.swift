//
//  Constants.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation

/// App-wide constants to avoid magic numbers and strings
enum Constants {

    // MARK: - Country List
    enum CountryList {
        /// Maximum number of countries allowed in the list
        static let maxCountries = 5

        /// Default country when location permission is denied
        static let defaultCountry = "Egypt"
    }

    // MARK: - UI Dimensions
    enum UI {
        static let cornerRadius: CGFloat = 15
        static let shadowRadius: CGFloat = 5
        static let flagImageSize: CGFloat = 32
        static let detailsFlagHeight: CGFloat = 200
        static let cardPadding: CGFloat = 16
        static let listRowSpacing: CGFloat = 12
    }

    // MARK: - Animation
    enum Animation {
        static let defaultDuration: Double = 0.3
    }
}
