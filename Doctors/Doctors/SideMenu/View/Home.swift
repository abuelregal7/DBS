//
//  Home.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 23/03/2024.
//

import SwiftUI

struct Home: View {
    
    @Binding var selectedTab : String
    @State var currentTab = "Home"
    var buttonAction: () -> Void
    
    init(selectedTab:Binding<String>, buttonAction: @escaping () -> Void) {
        self.buttonAction = buttonAction
        self._selectedTab = selectedTab
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing:0) {
            TabView(selection:$selectedTab){
                //views
                HomeView(buttonAction: {buttonAction()})
                    .tag("Home")
            }
        }
    }
}

#Preview {
    Home(selectedTab: .constant(""), buttonAction: { })
}
