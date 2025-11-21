//
//  ReservationsApp.swift
//  Reservations
//
//  Created by Ahmed Abo Al-Regal on 02/01/2024.
//

import SwiftUI

@main
struct ReservationsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
            //DropDownSectionsList()
            //CarouselContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
