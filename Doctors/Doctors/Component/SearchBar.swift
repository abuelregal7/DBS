//
//  SearchBar.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 27/03/2024.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchText = ""
    @State private var searchResults: [String] = []
    
    var body: some View {
        VStack {
            HStack(spacing:10){
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                
                TextField("Search for doctor name, clinic...", text: $searchText, onCommit: search)
                    .font(.custom(GFFonts.Segui, size: 14))
                    .foregroundColor(Color.gray)
                    .padding(.vertical, 10)
                    .padding(.trailing, 8)
                
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.white)
                .shadow(
                    color: Color.gray.opacity(0.3),
                    radius: 4,
                    x: 2,
                    y: 2
                )
        )
        .frame(width: UIScreen.main.bounds.width - 40, height: 50)
    }
    
    func search() {
        // Perform search logic here
        searchResults = ["Result 1", "Result 2", "Result 3"].filter { $0.contains(searchText) }
    }
}



#Preview {
    SearchBar()
}
