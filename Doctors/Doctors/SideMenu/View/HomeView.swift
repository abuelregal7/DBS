//
//  HomeView.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 21/11/2025.
//

import SwiftUI

struct HomeView: View {
    
    var buttonAction: () -> Void
    
    struct Category {
        let name: String
        let imageName: String
        let destinationView: AnyView
    }
    
    // MARK:- VIEW
    
    var body: some View {
        NavigationView{
            ScrollView (.vertical, showsIndicators: false){
                Text("HOME SCREEN")
            }.navigationBarItems(
                leading:
                    Button {
                       buttonAction()
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.gray)
                    },
                trailing:
                    NavigationLink(destination: SearchBar()) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    }
            )
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}


#Preview {
    HomeView(buttonAction: {})
}
