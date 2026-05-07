//
//  DetailRouter.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import SwiftUI

class DetailRouter {
    
    var view: (any View)?
        
    static func createModule(with country: WorldCountry) -> some View {
                
        let router = DetailRouter()
        let viewModel = DetailViewModel(country: country)
        let view = DetailView(viewModel: viewModel)
        router.view = view
        return view
    }
}
