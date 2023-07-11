//
//  PlatzyChallengeApp.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 10/07/23.
//

import SwiftUI

@main
struct PlatzyChallengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
