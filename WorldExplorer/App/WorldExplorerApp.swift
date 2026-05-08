//
//  WorldExplorerApp.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import SwiftUI

@main
struct WorldExplorerApp: App {

    var body: some Scene {
        WindowGroup {
            ExplorerRouter.createModule()
        }
    }
}
