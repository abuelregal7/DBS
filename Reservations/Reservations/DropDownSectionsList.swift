//
//  DropDownSectionsList.swift
//  Reservations
//
//  Created by Ahmed Abo Al-Regal on 16/07/2024.
//

import SwiftUI

struct SectionView: View {
    let sectionTitle: String
    
    @State private var isExpanded = false
    @State private var searchText = ""
    let options = ["Option 1", "Option 2", "Option 3", "Option 1", "Option 2", "Option 3"]

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(sectionTitle)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    }
                    .frame(height: 40)
                    .padding()
                    .background(Color.blue.opacity(0.2)) // Blue background with opacity
                    .cornerRadius(8)
                }
                
                if isExpanded {
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $searchText)
                            .padding()
                        
//                        List {
//                            ForEach(options.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { option in
//                                Text(option)
//                                    //.frame(maxWidth: .infinity)
//                                    .padding(7)
//                                    .padding(.horizontal, 25)
//                                    .background(Color.white)
//                                    .cornerRadius(8)
//                            }
//                        }
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .listStyle(PlainListStyle()) // Use PlainListStyle to minimize default section styling
//                        .listRowSpacing(10)
//                        .padding([.leading, .trailing], 0)
                        
                        ForEach(options.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { option in
                            Text(option)
                                //.frame(maxWidth: .infinity)
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                    //.frame(maxWidth: .infinity) // Take full width
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.bottom, 25)
                    
                }
            }
            .padding(.bottom)
        }
    }
}

struct DropDownSectionsList: View {
    let sections = ["Section 1", "Section 2", "Section 3"] // Add your section titles here

    var body: some View {
        List {
            ForEach(sections, id: \.self) { section in
                Section {
                    SectionView(sectionTitle: section)
                }
                .listRowSeparator(.hidden)
                //.listRowBackground(Color.blue.opacity(0.2)) // Set list row background
            }
        }
        .listStyle(PlainListStyle()) // Use PlainListStyle to minimize default section styling
        .listRowSpacing(10)
        .padding([.leading, .trailing], 0) // Adjust padding to take full width
    }
}

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}

struct DropDownSectionsList_Previews: PreviewProvider {
    static var previews: some View {
        DropDownSectionsList()
    }
}
