//
//  ExplorerRouter.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import SwiftUI

class ExplorerRouter {
    
    var view: (any View)?
        
    static func createModule() -> some View {
        
        let locationManager = LocationManager()
        
        let router = ExplorerRouter()
        let useCase = ExplorerUseCase(searchRepo: ExplorerRepository())
        let viewModel = ExplorerViewModel(useCase: useCase,
                                             locationManager: locationManager)
        let view = ExplorerView(viewModel: viewModel)
        router.view = view
        return view
    }
}
