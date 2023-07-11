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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
