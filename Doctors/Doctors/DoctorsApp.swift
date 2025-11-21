//
//  DoctorsApp.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 2023-10-27.
//

import SwiftUI

@main
struct DoctorsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //ContentView()
            OnboardingView()
            //SideMenuView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
