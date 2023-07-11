//
//  PlatzyChallengeApp.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 10/07/23.
//

import SwiftUI

@main
struct PlatzyChallengeApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(networkMonitor)
        }
    }
}
