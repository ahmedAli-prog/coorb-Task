//
//  Environment.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import Foundation

enum Environment {

    static var baseUrl: String {

        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {

            fatalError("Missing InfoPlist BaseURL")
        }
        return urlString
    }
}
