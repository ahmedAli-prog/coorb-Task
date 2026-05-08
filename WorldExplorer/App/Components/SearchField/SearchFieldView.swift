//
//  SearchFieldView.swift
//  WorldExplorer
//
//  Created by ahmed ali on 7/5/26.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            
            TextField("Search...", text: $searchText)
                .padding(12)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)
            
            Button(action: { onSearch() }) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title)
            }
            .padding(.trailing)
        }
        .padding(.top)
    }
}
